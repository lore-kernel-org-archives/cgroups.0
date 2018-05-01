From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v7 4/5] cpuset: Restrict load balancing off cpus to
 subset of cpus.isolated
Date: Tue, 1 May 2018 13:58:28 -0700
Message-ID: <20180501205828.GD2368884@devbig577.frc2.facebook.com>
References: <1524145624-23655-1-git-send-email-longman@redhat.com>
 <1524145624-23655-5-git-send-email-longman@redhat.com>
 <20180501195148.GC2368884@devbig577.frc2.facebook.com>
 <9eb2c45e-e71e-61ef-aa6d-b8124b739cdf@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=WvhHY4fPhryLktWbybz763iqvA13BRrsRv4zb9q1pvo=;
        b=lD0D5OR/d91PrZMHD8zAp5N6a0z5HHjHB91JxDSnEQmZxaacCcqdH2HKO5IU7W7FQO
         jc84LP+D/0qjCn/BPpQwL18B3ApvtjHgQuDT/oZiUl5EtidhgePdkEttSLB9UiETkju2
         8VnsH8MQ3jwIQwxaPAC3aW8sndN7hOGAR59dJrAp/p6agzK5YvHP/E0U8Jy/cn5QOAeP
         H8+cFB5zoMKGccs4lc/LtoKNmG4+2P4tsWRr/WL6Hf8hPgMBP0HXSyDYu7Q7gQIOkjmT
         4hWGx5h+7GoD5pxiwvJgFFrOD0Vl2z2nT3zqLLMzcHl7dpok2uHxtnyN/z2ZgYGKQbZw
         OTGA==
Content-Disposition: inline
In-Reply-To: <9eb2c45e-e71e-61ef-aa6d-b8124b739cdf@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, Mike Galbraith <efault@gmx.de>, torvalds@linux-foundation.org, Roman Gushchin <guro@fb.com>, Juri Lelli <juri.lelli@redhat.com>

Hello,

On Tue, May 01, 2018 at 04:33:45PM -0400, Waiman Long wrote:
> I think that will work too. We currently don't have a flag to make a
> file visible on first-level children only, but it shouldn't be hard to
> make one.

I think it'd be fine to make the flag file exist on all !root cgroups
but only writable on the first level children.

> Putting CPUs into an isolated child cpuset means removing it from the
> root's effective CPUs. So I would probably like to expose the read-only
> cpus.effective in the root cgroup so that we can check changes in the
> effective cpu list.

Ah, yeah, that makes sense.

> I will renew the patchset will your suggestion.

Thank you very much.

-- 
tejun
