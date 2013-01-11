From: Colin Cross <ccross-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: synchronize_rcu in cgroup_attach_task and cgroup_attach_proc
Date: Fri, 11 Jan 2013 15:48:42 -0800
Message-ID: <CAMbhsRQo3mjSMWTtUzqaHbeZqVYafzUjoweWa9Oz3QNRM46PVQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        bh=py/LvMlgJSwxuuxfbiy0MeHZcgBihMf1VZobFy51wrM=;
        b=OimRKfde2wFj9FlQt91eXDXmnHfMp4OLo6znz6KnejQJKpwRsR5HRPqS/6t7vdjeIy
         Ha2KvBb/SMYU2phQ5g1E6E+8ENUrwqsOpfsKR8hSQXfpAYfsYXPV9kO8zZvr8qEYhoVs
         U1INxkaoHWK40jzrGE5zCxg64dJpEIE2LFRZYuEJoJipOzsXYl99/t+id5QKf9Uo7cmq
         8aLLRGtgPvoVJMlhmCWVTBX2wshq7DR/i9q2ikukyj+wemzOLFbQVs+3u6u+XKBzOzmz
         d/QtjyZurJsHB6GwuaZQhLgkMS1PinFL5wd4hhEd1y46OoF1KdPvJ40N2IeQDBz37Wng
         Brhw==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Quick background:  Android uses cgroups heavily to manage thread
priorities, putting threads in a background group with reduced
cpu.shares when they are not visible to the user, and in a foreground
group when they are.  Some RPCs from foreground threads to background
threads will temporarily move the background thread into the
foreground group for the duration of the RPC.  This results in many
calls to cgroup_attach_task.

The call to synchronize_rcu() in cgroup_attach_task and
cgroup_attach_proc can take up to 100ms, and averages 50ms on Nexus 10
(ARM Exynos5250 SoC) when the cpus are all idle, and similar times
have been measured on multiple other ARM SMP SoCs.

I worked with Paul around v3.0 to try to remove the synchronize_rcu
calls (see https://android.googlesource.com/kernel/common/+/befae2f2c9137d6af5c8b38670f00441019032bb),
but nobody seemed to have a clear understanding of the full extent of
what the synchronize_rcu was protecting.  Since then the relevant
code, especially cgroup_rmdir, has been heavily rewritten, so
hopefully someone understands it better now.

The only rcu-protected variable updated in cgroup_attach_task is
tsk->cgroups.  Freeing the old tsk->cgroups is already rcu-protected
by kfree_rcu in __put_css_set.  The only thing that happens before
cgroup_attach_task returns out to userspace is threadgroup_unlock and
cgroup_unlock.  Is anything relying on cgroup_mutex to be held for an
RCU grace period?  If not, it seems like the synchronize_rcu isn't
protecting anything and is just wasting time.
