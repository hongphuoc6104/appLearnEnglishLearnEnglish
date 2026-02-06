import os
q = chr(39)
base = '/home/hongphuoc/Desktop/LearnEnglish/mobile/lib/domain'
for fn in ['repositories/ai_repository.dart', 'usecases/generate_quiz_usecase.dart']:
    p = base + '/' + fn
    c = open(p).read()
    c = c.replace('String type,', 'String type = ' + q + 'mcq' + q + ',')
    c = c.replace('String difficulty}', 'String difficulty = ' + q + 'intermediate' + q + '}')
    c = c.replace('String difficulty})', 'String difficulty = ' + q + 'intermediate' + q + '})')
    open(p, 'w').write(c)
    print('Fixed: ' + fn)
