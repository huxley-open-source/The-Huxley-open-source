#!/bin/sh

NAME="th"
HOME_DIR="/home/support"
PROJECT_DIR="/projetos/huxley"
JAVA_DIR="/opt/jdk1.7.0"
WORKSPACE_DIR="/workspace/The-Huxley"

prod() {
    ssh -t support@thehuxley.com "
        cd $HOME_DIR$PROJECT_DIR$WORKSPACE_DIR;
        git pull origin master;
        sudo rm $HOME_DIR$PROJECT_DIR/huxley.war;
        sudo rm -r $HOME_DIR$PROJECT_DIR$WORKSPACE_DIR/target
        export JAVA_HOME=$JAVA_DIR;
        $HOME_DIR$PROJECT_DIR/ferramentas/grails-2.0.4/bin/grails war ../../huxley.war;
        sudo /etc/init.d/tomcat6 stop;
        sudo rm -r /var/lib/tomcat6/webapps/huxley;
        sudo mv /var/lib/tomcat6/webapps/huxley.war $HOME_DIR/huxley.war.old;
        sudo cp $HOME_DIR$PROJECT_DIR/huxley.war /var/lib/tomcat6/webapps/;
        sudo /etc/init.d/tomcat6 start;
        sudo /etc/init.d/apache2 restart;
    "
}

rollback() {
    ssh -t support@thehuxley.com "
        sudo /etc/init.d/tomcat6 stop;
        sudo rm -r /var/lib/tomcat6/webapps/huxley;
        sudo mv $HOME_DIR/huxley.war.old /var/lib/tomcat6/webapps/huxley.war;
        sudo /etc/init.d/tomcat6 start;
        sudo /etc/init.d/apache2 restart;
    "
}

help() {
    echo "Uso: $NAME {deploy|rollback}"
}

case $1 in
    deploy)
        prod
    ;;

    rollback)
        rollback
    ;;

    *)
        help
    ;;
esac