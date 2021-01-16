From: Odin Ugedal <odin-RObV4cXtwVA@public.gmane.org>
Subject: [PATCH v2 0/2] cgroup: fix psi monitor for root cgroup
Date: Sat, 16 Jan 2021 18:36:32 +0100
Message-ID: <20210116173634.1615875-1-odin@uged.al>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=uged.al; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qlad5VW9NeTfqd7HA+X6a+dEIIhoJaZNTXpl9GukvIg=;
        b=rdynwu6bHUZrdSUIffJFVlTKwxUfvEJLKYOps0F8p2xAZUB9o2Ey5tnt8NIQ/T9O5T
         7jeR2T+kiIoWrbndyxOIQinPHeg++cYdme7BJXM4navMCdE3TNy1ml/QDrkxTNC10+dW
         on/TjpuO3KvjmWPYJuGAfaJfyaNMtJAONrJgbCNO8CA3J1O+sjkWvWPpzd2VsE/09C9X
         RMajlIq9rQjb+RryBYdSuhsJXoEiTlJYWq3hR01XVojO06IZAS3r/DxH94sJb7gUz0Bp
         3Anl3Az9N4VdOHUXx03+fNHNEneBDB3qvl04wUG1izBShX15nXqWocTu2xjz7rYq0dPq
         Avxw==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: 
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dschatzberg-b10kYP2dOMg@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Odin Ugedal <odin-RObV4cXtwVA@public.gmane.org>

This patchset fixes PSI monitors on the root cgroup, as they currently
only works on the non-root cgroups. Reading works for all, since that
was fixed when adding support for the root PSI files. It also contains
a doc update to reflect the current implementation.

Changes since v1:
 - Added Reviewed-by tag on the original patch (Suren)
 - Updated patch title
 - Added a separate patch to update doc


Odin Ugedal (2):
  cgroup: fix psi monitor for root cgroup
  cgroup: update PSI file description in docs

 Documentation/admin-guide/cgroup-v2.rst | 6 +++---
 kernel/cgroup/cgroup.c                  | 4 +++-
 2 files changed, 6 insertions(+), 4 deletions(-)

-- 
2.30.0

