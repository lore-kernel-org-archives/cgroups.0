From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v5 1/2] cpuset: Enable cpuset controller in default
 hierarchy
Date: Tue, 20 Mar 2018 13:10:29 -0700
Message-ID: <20180320201029.GO519464@devbig577.frc2.facebook.com>
References: <1521148842-15486-1-git-send-email-longman@redhat.com>
 <1521148842-15486-2-git-send-email-longman@redhat.com>
 <20180319155937.GQ2943022@devbig577.frc2.facebook.com>
 <1881c1da-56ec-d76b-b736-fd0919737ec6@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=lAiQqpCcQDlXQITgI8JJALMA48DylJdpE65IrtFSPRE=;
        b=K3gaUsQtRdZaUajGpvLBM5j33738ehWUwPGd2E8Lp67tBrcaKQvW/SkMvRqcCffEHT
         LdgsAmz6aIlLoqSn+03YkZttjCgVebIT05v6UQncqYcb0DniCuIBRZZzmNYM+RushySo
         M5TLKUqdaHtBHFasHL/8Ksuvg6loIjsCgw6J3RDoC6717Yr3HUgY7m5jt1PzUJRwwIE/
         odVpgyhfXYO6PjqFSvIESIv5Z6Hv1IGZgbSCGs+jPoeqt62XquCfR/P8H0b0XnNzTb5L
         CRJIJkH9z3WxQBVqD6+LX4gNsKEHAeGWsS2/Bi9fOkRBNZl3+DfuwYJ+v2AOPn+JXmZ9
         E1/A==
Content-Disposition: inline
In-Reply-To: <1881c1da-56ec-d76b-b736-fd0919737ec6@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, efault@gmx.de, torvalds@linux-foundation.org, Roman Gushchin <guro@fb.com>

Hello, Waiman.

On Tue, Mar 20, 2018 at 09:51:20AM -0400, Waiman Long wrote:
> >> +	It lists the onlined CPUs that are actually allowed to be
> >> +	used by tasks within the current cgroup. It is a subset of
> >> +	"cpuset.cpus".  Its value will be affected by CPU hotplug
> >> +	events.
> > Can we do cpuset.cpus.availble which lists the cpus available to the
> > cgroup instead of the eventual computed mask for the cgroup?  That'd
> > be more useful as it doesn't lose the information by and'ing what's
> > available with the cgroup's mask and it's trivial to determine the
> > effective from the two masks.
> 
> I don't get what you want here. cpus is the cpuset's cpus_allowed mask.
> effective_cpus is the effective_cpus mask. When you say cpus available
> to the cgroup, do you mean the cpu_online_mask or the list of cpus from
> the parent? Or do you just want to change the name to cpus.available
> instead of effective_cpus?

The available cpus from the parent, where the effective is AND between
cpuset.available and cpuset.cpus of the cgroup, so that the user can
see what's available for the cgroup unfiltered by cpuset.cpus.

> Right, I will set CFTYPE_NOT_ON_ROOT to "cpus" and "mems" as we are not
> supposed to change them in the root. The effective_cpus and
> effective_mems will be there in the root to show what are available.

So, we can do that in the future but let's not do that for now.  It's
the same problem we have for basically everything else and we've
stayed away from replicating the information in the root cgroup.  This
might change in the future but if we do that let's do that
consistently.

Thanks.

-- 
tejun
