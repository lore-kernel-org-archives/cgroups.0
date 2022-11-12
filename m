From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 0/2] cgroup/cpuset: v2 optimization
Date: Sat, 12 Nov 2022 17:19:37 -0500
Message-ID: <20221112221939.1272764-1-longman@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668291610;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=hPqQ7pS391n2tdE33js5OayByAWbyhFUU/9GmPjNmvs=;
        b=FxhmZURPYpYEqY7NdrWnQg4M0Yw5WeuI9c82qvCnqeFGdOnDgA/UTfI7xb67XFsEk1nwYp
        Vcfj7WRnTX9HoT6+4XUr+6xUEekfq73Fl72sdaVaAM4/+VY5OVyjc5iT7/LzDDP+xtCXQT
        6uPy1PcauVSj5jbtm5YxllZfvEtom6M=
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

This patchset contains 2 patches to optimize out unneeded works when
running on a cgroup v2 environment.

Waiman Long (2):
  cgroup/cpuset: Skip spread flags update on v2
  cgroup/cpuset: Optimize cpuset_attach() on v2

 kernel/cgroup/cpuset.c | 36 +++++++++++++++++++++++++++++++-----
 1 file changed, 31 insertions(+), 5 deletions(-)

-- 
2.31.1

