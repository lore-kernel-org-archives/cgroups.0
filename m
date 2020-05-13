From: Jan Stancek <jstancek-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: 
 =?utf-8?q?=E2=9D=8C_FAIL=3A_Test_report_for_kernel=095=2E7?=
 =?utf-8?q?=2E0-rc5-51f14e2=2Ecki_=28arm-next=29?=
Date: Wed, 13 May 2020 11:40:15 -0400 (EDT)
Message-ID: <1039472143.12305448.1589384415559.JavaMail.zimbra@redhat.com>
References: <cki.495C39BD1A.T35Z6VDJPY@redhat.com>
 <20200513060321.GA17433@willie-the-truck>
 <1322199095.22739428.1589365183678.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <ltp-bounces+glt-ltp-list=m.gmane-mx.org-cunTk1MwBs91InPhgRC9rw@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1589384428;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=0Rwauy6ze7wp8liue4GeJex+DR2vmusIwZACZsakXMw=;
 b=CRAcSXo/VSqDSb/GjajnXhMN4NO2d8VkiTxSqr1zts94KbaqaT1goEgcxmXrt52sHtbrpr
 Ch/IASRGjqBno8JFcXvlarLjAUg9wFsR88C0fcQAgVQ5KDCioaEusPVoZjpQExlhQtOYmm
 Y2cZMoVFie1hXiNj3mrxTArsaQSnajw=
In-Reply-To: <1322199095.22739428.1589365183678.JavaMail.zimbra-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <https://lists.linux.it/options/ltp>,
 <mailto:ltp-request-cunTk1MwBs91InPhgRC9rw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linux.it/pipermail/ltp/>
List-Post: <mailto:ltp-cunTk1MwBs91InPhgRC9rw@public.gmane.org>
List-Help: <mailto:ltp-request-cunTk1MwBs91InPhgRC9rw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linux.it/listinfo/ltp>,
 <mailto:ltp-request-cunTk1MwBs91InPhgRC9rw@public.gmane.org?subject=subscribe>
Errors-To: ltp-bounces+glt-ltp-list=m.gmane-mx.org-cunTk1MwBs91InPhgRC9rw@public.gmane.org
Sender: "ltp" <ltp-bounces+glt-ltp-list=m.gmane-mx.org-cunTk1MwBs91InPhgRC9rw@public.gmane.org>
To: Veronika Kabatova <vkabatov-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: catalin marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Memory Management <mm-qe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, CKI Project <cki-project-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Will Deacon <will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, LTP List <ltp-cunTk1MwBs91InPhgRC9rw@public.gmane.org>



----- Original Message -----
> >        Kernel repo: https://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git
> >            Commit: 51f14e2c02e8 - Merge branch 'for-next/core' into for-kernelci
> >
> > I'm struggling a bit with this one, please can you confirm that it's not
> > an issue on your end? The failures are related to /dev/cpuset:
> > 
> >   mem.c:760: BROK: mount /dev/cpuset: EBUSY (16)
> >   ...
> >   safe_macros.c:172: BROK: mem.c:750: mkdir(/dev/cpuset,0777) failed:
> >   EEXIST
> >   (17)
> > 
> >   https://cki-artifacts.s3.us-east-2.amazonaws.com/datawarehouse/2020/05/12/564910/LTP/aarch64_2_ltp_mm.fail.log
> > 
> > But we haven't been anywhere near that in the arm64 tree afaik.
> > 
> 
> Hi,
> 
> I suspect this is an LTP bug:
> 
> https://github.com/linux-test-project/ltp/issues/611

[CC cgroups & LTP]

In LTP issue above it was clear that memory controller is in use.
Here it looks like some lingering reference to cpuset controller
that can't be seen in sysfs.

It's triggered by podman tests actually:
1. run podman tests
2. mount -t cgroup -ocpuset cpuset /mnt/cpuset/ -> EBUSY

# mount | grep cgroup
cgroup2 on /sys/fs/cgroup type cgroup2 (rw,nosuid,nodev,noexec,relatime,seclabel)

# grep cpuset -r /sys/fs/cgroup/
/sys/fs/cgroup/cgroup.controllers:cpuset cpu io memory pids

And yet, v1 cgroup fails to mount:

# mount -t cgroup -ocpuset cpuset /mnt/cpuset/
mount: /mnt/cpuset: cpuset already mounted or mount point busy.

Fail state persists also after I disable all controllers and move
all processes to root:

# cat /sys/fs/cgroup/cgroup.subtree_control
# ll /sys/fs/cgroup/
total 0
-r--r--r--. 1 root root 0 May 13 10:35 cgroup.controllers
-rw-r--r--. 1 root root 0 May 13 10:44 cgroup.max.depth
-rw-r--r--. 1 root root 0 May 13 10:44 cgroup.max.descendants
-rw-r--r--. 1 root root 0 May 13 10:58 cgroup.procs
-r--r--r--. 1 root root 0 May 13 10:44 cgroup.stat
-rw-r--r--. 1 root root 0 May 13 11:00 cgroup.subtree_control
-rw-r--r--. 1 root root 0 May 13 10:44 cgroup.threads
-rw-r--r--. 1 root root 0 May 13 10:44 cpu.pressure
-r--r--r--. 1 root root 0 May 13 10:44 cpuset.cpus.effective
-r--r--r--. 1 root root 0 May 13 10:44 cpuset.mems.effective
-rw-r--r--. 1 root root 0 May 13 10:44 io.cost.model
-rw-r--r--. 1 root root 0 May 13 10:44 io.cost.qos
-rw-r--r--. 1 root root 0 May 13 10:44 io.pressure
-rw-r--r--. 1 root root 0 May 13 10:44 memory.pressure

# mount -t cgroup -ocpuset cpuset /mnt/cpuset/
mount: /mnt/cpuset: cpuset already mounted or mount point busy

If I reboot and don't run any podman tests, v1 cgroup mounts fine:

# cat /sys/fs/cgroup/cgroup.controllers
cpuset cpu io memory pids
# mount -t cgroup -ocpuset cpuset /mnt/cpuset/
# cat /sys/fs/cgroup/cgroup.controllers
cpu io memory pids
# umount /mnt/cpuset/
# cat /sys/fs/cgroup/cgroup.controllers
cpuset cpu io memory pids


-- 
Mailing list info: https://lists.linux.it/listinfo/ltp
