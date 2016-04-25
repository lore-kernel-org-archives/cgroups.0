From: Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
Subject: cgroup namespace and user namespace interactions
Date: Tue, 26 Apr 2016 04:37:01 +1000
Message-ID: <CAOviyaiusbQya9KtcE5+RyY5qKq51DL5_VQtcHP7jVkehLmRyQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cyphar-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:date:message-id:subject:from:to:cc;
        bh=SH4j1eSlF+yc1xfuqoLEsVf3Oob7JvYyrugb8MQxwQc=;
        b=mn1jRZEwIXhaDE/9s7bdgPvBCXtaqQSiZwo1zHtSFWrHOlLoTifaE2Fe5ykryTDbhL
         IocpuWMUZI8YUqWWPrT37JsTrZz8rV/Xkua8WVnmSomQrSmKYXit7/j6otC/Ctp6LWbS
         KNH2AbU1OaLH2cvN8tRUozEaRaw3/jTjs6/QNMD/V6FDNm+ULSzySyhmAbyjZwz/qJUr
         RzdSRvQHf5k+VZDUM2iFTrjHc1+strf1gx0UbK9VNA33L9h3X6A6FEg4BZh09ZfqoPYF
         Nb/j9EaXKHU7lHeHVmvR+s+EcoXnEPaJtyqHp37g5mhUjuAoDDUQPlPmwJ798J2S0qlw
         8wYA==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

The new cgroup namespace currently only allows for superficial
interaction with the user namespace (it checks against the namespace
it was created in whether or not a user has the right capabilities
before allowing mounting, and things like that). However, there is one
glaring feature that appears to be missing from the new cgroup
namespace implementation: unprivileged user namespaces can't modify
their sub-hierarchy. This is particularly frustrating for the
containerisation community, where we are working on adding support for
"rootless containers" in runC (the execution driver of Docker)[1]. It
essentially means that we can't use cgroup resource limiting to limit
*the resources of our own processes*. It also makes things like the
freezer cgroup unusable.

Here follows how I think we can solve this issue: the most obvious way
of dealing with this would be (in the cgroupv1 view) to create a new
subtree in every controller when you CLONE_NEWCGROUP. This new subtree
is the root of the process's cgroup hierarchy. This doesn't affect any
resource control, but it will result in the process only being able to
affect its *own* resources. However, for cgroupv2 we have the "No
Internal Process Constraint". So, maybe we could also move all of the
other processes into a sibling subtree (with the *exact same* access
permissions as the parent). Thus, the operation would look like this:

- C0 - P00
       \ P01
       \ P02 (about to setns)

becomes

- C0 - C00 - P00
                 \ P01
       \ C01 - P02

But then we have C00 which is just a waste of cycles (it doesn't have
any resource settings). So maybe there's some optimisation we can do
there, but that's as far as I've gotten into thinking about how to
deal with the constraints of cgroupv2. After that's been solved we can
reuse how we store the user namespace the cgroup was created in
(cgroup_namespace.user_ns), and just check that whatever user is
trying to modify the cgroup has CAP_SYS_ADMIN in that user namespace.

Do you think this would work? Are there any recommendations on whether
we can make this work better? Also, can you clarify whether or not
CLONE_NEWCGROUP only works for cgroupv2 or does it also work on
cgroupv1 (we haven't yet transitioned to cgroupv2 in runC).

Thanks.

[1]: https://github.com/opencontainers/runc/pull/774

-- 
Aleksa Sarai (cyphar)
www.cyphar.com
