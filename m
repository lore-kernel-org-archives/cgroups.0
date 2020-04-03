From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: Deadlock due to "cpuset: Make cpuset hotplug synchronous"
Date: Fri, 3 Apr 2020 10:54:18 -0400
Message-ID: <20200403145418.GB162390@mtj.duckdns.org>
References: <F0388D99-84D7-453B-9B6B-EEFF0E7BE4CC@lca.pw>
 <20200325191922.GM162390@mtj.duckdns.org>
 <6AD62381-394F-4742-816B-12DE67DE9788@lca.pw>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=Qyus9wEurAIsnv0KktXUQAPVSjugd3/P/58Fl3RicEU=;
        b=AsMjO4gFG/KXUlzlax7BKYVPEzhqXKQC1Xgj+6ktBQX8c79pf9D9fDvjN0PhCoBALB
         NYUDhQGz+MFxBY/tKwUkORWhVJPah3s36fFIe1usQXybxHqknrWgb5LGQopO7mDMwt9s
         13PIz1GKaNUteJUiZr2asCr+CwNxf/FALTr+MP6W0AcE3pvVmgltqKj+MVNIP6QzaUzF
         vyBN0pHykga9tV1YgB6OqZy9QlylEz2/psehTECYZtoRFA+proI997MDHcKhy3Su8HJz
         dv7wL63P4+DjSgV/KuLlWlKFoiQ+EEZI3keIoEGHiKIoEcRVx9H8q8cDQWx4re3y3U38
         +9Mg==
Content-Disposition: inline
In-Reply-To: <6AD62381-394F-4742-816B-12DE67DE9788-J5quhbR+WMc@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Qian Cai <cai-J5quhbR+WMc@public.gmane.org>
Cc: Prateek Sood <prsood-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>

On Wed, Apr 01, 2020 at 10:00:31PM -0400, Qian Cai wrote:
> 
> 
> > On Mar 25, 2020, at 3:19 PM, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> > 
> > On Wed, Mar 25, 2020 at 03:16:56PM -0400, Qian Cai wrote:
> >> The linux-next commit a49e4629b5ed (“cpuset: Make cpuset hotplug synchronous”)
> >> introduced real deadlocks with CPU hotplug as showed in the lockdep splat, since it is
> >> now making a relation from cpu_hotplug_lock —> cgroup_mutex.
> > 
> > Prateek, can you please take a look? Given that the merge window is just around
> > the corner, we might have to revert and retry later if it can't be resolved
> > quickly.
> 
> Tejun, can you back off this commit now given it seems nobody is trying to rescue it?

Yeah, gonna revert it before sending out the pull request.

Thanks.

-- 
tejun
