From: Vipin Sharma <vipinsh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [RFC 0/2] cgroup: New misc cgroup controller
Date: Thu, 18 Feb 2021 11:55:47 -0800
Message-ID: <20210218195549.1696769-1-vipinsh@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=7bVBB7/eb43F7sJCb2A73jGKQH5d6crP4qDBABCXugI=;
        b=MSGiXWGc/XBlhRD4FT6+UEMZ+VJARxb3RibM8Xi7pgr9pz0bgTNlOAetGX3p8x57hC
         D9NGC/+GSPxXLIuX4N+ZhEma+EfYEksySW3hvgaO5RI92DO3YOkf+l3+Hz/4dRKkCJdf
         4cMVb+Q2gHQlbE6XqbqTxkfw4bfAhObx0/dyqaDQRbt5/srIvx75jQGbX1PbYcJkSlg8
         hI0qu06XNCzJQ1hwwZl3Vi7StUkGbOxBPOtK7067VGnDl7Ahv9l8EKanVlB9gfUPJ6gp
         ChDRajvVL/VyOf74x+UM1yxcIda7D3fmjy8aa7r0MT38Aa/sNHX4SLupLZYl1t5ZYLIJ
         5EvQ==
Sender: "vipinsh via sendgmr" <vipinsh-brn8i7wjtNULry5u5tX/RU7CuiCeIGUxQQ4Iyu8u01E@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, thomas.lendacky-5C7GfCeVMHo@public.gmane.org, brijesh.singh-5C7GfCeVMHo@public.gmane.org, jon.grimm-5C7GfCeVMHo@public.gmane.org, eric.vantassell-5C7GfCeVMHo@public.gmane.org, pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, frankja-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org, borntraeger-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org
Cc: corbet-T1hC0tSOHrs@public.gmane.org, seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, vkuznets-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, wanpengli-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org, jmattson-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, gingell-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, dionnaglaze-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Vipin Sharma <vipinsh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Hello,

This patch is creating a new misc cgroup controller for allocation and
tracking of resources which are not abstract like other cgroup
controllers.

This controller was initially proposed as encryption_id but after
the feedbacks, it is now changed to misc cgroup.
https://lore.kernel.org/lkml/20210108012846.4134815-2-vipinsh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org/

Changes from the encryption_id controller are:
1. There are only 3 files misc.{capacity, max, current} for all
   resources compared to each resource having their own 3 files in
   encryption_id cgroup.
2. If a resource capacity is 0 then it is considered inactive and won't
   show up in control files.
2. This is a lockless implementation similar to page counter APIs
   compared to single lock implementation in encryption_id cgroup.

Please provide any feedback for this RFC or if it is good for
merging then I can send a patch for merging.

Thanks

Vipin Sharma (2):
  cgroup: sev: Add misc cgroup controller
  cgroup: sev: Miscellaneous cgroup documentation.

 Documentation/admin-guide/cgroup-v1/misc.rst |   1 +
 Documentation/admin-guide/cgroup-v2.rst      |  64 ++-
 arch/x86/kvm/svm/sev.c                       |  60 ++-
 arch/x86/kvm/svm/svm.h                       |   1 +
 include/linux/cgroup_subsys.h                |   4 +
 include/linux/misc_cgroup.h                  |  75 +++
 init/Kconfig                                 |  14 +
 kernel/cgroup/Makefile                       |   1 +
 kernel/cgroup/misc.c                         | 456 +++++++++++++++++++
 9 files changed, 664 insertions(+), 12 deletions(-)
 create mode 100644 Documentation/admin-guide/cgroup-v1/misc.rst
 create mode 100644 include/linux/misc_cgroup.h
 create mode 100644 kernel/cgroup/misc.c

-- 
2.30.0.617.g56c4b15f3c-goog

