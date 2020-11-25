import com.thehuxley.License
import com.thehuxley.LicenseType
import com.thehuxley.ShiroUser


class BootStrap {
    def mongoService
    def init = { servletContext ->
        mongoService.generateProblemList()
        if (LicenseType.list().size() <= 0) {
            def licenseType = new LicenseType()

            licenseType.name = "Licença padrão para Administradores do Sistema"
            licenseType.description = "Licença padrão para Administradores do Sistema, concede acesso total a todos os recursos do sistema."
            licenseType.descriptor = "STANDARD_ADMIN_LICENSE"
            licenseType.kind = LicenseType.ADMIN
            licenseType.save()

            licenseType = new LicenseType()
            licenseType.name = "Licença padrão para Estudantes"
            licenseType.description = "Licença padrão para estudantes, concede acesso as funcionalidades básicas, como submeter respostas de problemas, ver conteúdos, responder questionários, participar de grupos, fazer perguntas no fórum, etc."
            licenseType.descriptor = "STANDARD_STUDENT_LICENSE"
            licenseType.kind = LicenseType.STUDENT
            licenseType.save()

            licenseType = new LicenseType()
            licenseType.name = "Licença padrão para Professores Administradores"
            licenseType.description = "Licença padrão para professores Administradores da instituição, permite ver diferenças entre a resposta obtida e a resposta esperada, adicionar novos problemas, adicionar conteúdo, criar questionários e recursos de administrador institucional"
            licenseType.descriptor = "STANDARD_TEACHER_ADMIN_LICENSE"
            licenseType.kind = LicenseType.ADMIN_INST
            licenseType.save()

            licenseType = new LicenseType()
            licenseType.name = "Licença padrão para Professores"
            licenseType.description = "Licença padrão para professores da instituição, permite ver diferenças entre a resposta obtida e a resposta esperada, adicionar novos problemas, adicionar conteúdo, criar questionários, etc."
            licenseType.descriptor = "STANDARD_TEACHER_LICENSE"
            licenseType.kind = LicenseType.TEACHER
            licenseType.save()

            licenseType = new LicenseType()
            licenseType.name = "Licença padrão para Monitores"
            licenseType.description = "Licença padrão para monitores da instituição, permite ver diferenças entre a resposta obtida e a resposta esperada, cadastrar problemas, criar questonários, adicionar conteúdo, etc."
            licenseType.descriptor = "STANDARD_TEACHER_ASSISTANT_LICENSE"
            licenseType.kind = LicenseType.TEACHER_ASSISTANT
            licenseType.save()

            licenseType = new LicenseType()
            licenseType.name = "Licença padrão para Administradores da Instituição"
            licenseType.description = "Licença padrão para Administradores do Sistema, pemite cadastrar novos usuários, gerenciar licenças, etc."
            licenseType.descriptor = "STANDARD_ADMIN_INST_LICENSE"
            licenseType.kind = LicenseType.ADMIN_INST
            licenseType.save()

            licenseType = new LicenseType()
            licenseType.name = "Licença básica para estudantes"
            licenseType.description = "Licença para estudantes, concede acesso as funcionalidades básicas do The Huxley."
            licenseType.descriptor = "BASIC_STUDENT_LICENSE"
            licenseType.kind = LicenseType.STUDENT
            licenseType.save()

            licenseType = new LicenseType()
            licenseType.name = "Licença padrão para Professores Administradores"
            licenseType.description = "Licença padrão para professores Administradores da instituição, permite ver diferenças entre a resposta obtida e a resposta esperada, adicionar novos problemas, adicionar conteúdo, criar questionários e recursos de administrador institucional"
            licenseType.descriptor = "STANDARD_TEACHER_ADMIN_LICENSE"
            licenseType.kind = LicenseType.ADMIN_INST
            licenseType.save()

            licenseType = new LicenseType()
            licenseType.name = "Licença básica para estudantes"
            licenseType.description = "Licença para estudantes, concede acesso as funcionalidades básicas do The Huxley."
            licenseType.descriptor = "BASIC_STUDENT_LICENSE"
            licenseType.kind = LicenseType.STUDENT
            licenseType.save()
        }



        if (License.list().size() <= 0) {
            def license = new License()
            license.active = true
            license.indefiniteValidity = true
            license.startDate = new Date()
            license.endDate = new Date()
            license.type = LicenseType.findAllByDescriptor('STANDARD_ADMIN_LICENSE')[0]
            license.user = ShiroUser.get(1)
            /*MessageDigest md = MessageDigest.getInstance("MD5")
            BigInteger generatedHash = new BigInteger(1, md.digest((System.nanoTime().toString()).getBytes()))
            license.hash = generatedHash.toString(16) */
            license.save()
            license.errors.each {
                println it
            }

            license = new License()
            license.active = true
            license.indefiniteValidity = true
            license.startDate = new Date()
            license.endDate = new Date()
            license.type = LicenseType.findAllByDescriptor('STANDARD_STUDENT_LICENSE')[0]
            license.user = ShiroUser.get(1)
            license.save()
            license.errors.each {
                println it
            }

            license = new License()
            license.active = true
            license.indefiniteValidity = true
            license.startDate = new Date()
            license.endDate = new Date()
            license.type = LicenseType.findAllByDescriptor('STANDARD_TEACHER_LICENSE')[0]
            license.user = ShiroUser.get(1)
            license.save()
            license.errors.each {
                println it
            }

            license = new License()
            license.active = true
            license.indefiniteValidity = true
            license.startDate = new Date()
            license.endDate = new Date()
            license.type = LicenseType.findAllByDescriptor('STANDARD_TEACHER_ASSISTANT_LICENSE')[0]
            license.user = ShiroUser.get(1)
            license.save()
            license.errors.each {
                println it
            }

            license = new License()
            license.active = true
            license.indefiniteValidity = true
            license.startDate = new Date()
            license.endDate = new Date()
            license.type = LicenseType.findAllByDescriptor('STANDARD_ADMIN_INST_LICENSE')[0]
            license.user = ShiroUser.get(1)
            license.save()
            license.errors.each {
                println it
            }

            license = new License()
            license.active = true
            license.indefiniteValidity = true
            license.startDate = new Date()
            license.endDate = new Date()
            license.type = LicenseType.findAllByDescriptor('STANDARD_TEACHER_ADMIN_LICENSE')[0]
            license.user = ShiroUser.get(1)
            license.save()
            license.errors.each {
                println it
            }

            license.active = true
            license.indefiniteValidity = true
            license.startDate = new Date()
            license.endDate = new Date()
            license.type = LicenseType.findAllByDescriptor('BASIC_STUDENT_LICENSE')[0]
            license.user = ShiroUser.get(1)
            license.save()
            license.errors.each {
                println it
            }
        }

    }
    def destroy = {
    }
}
