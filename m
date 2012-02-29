From: Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 02/10] memcg: Uncharge all kmem when deleting a cgroup.
Date: Tue, 28 Feb 2012 16:24:55 -0800
Message-ID: <CABCjUKDYUwR9FsjFW_Ea30zbvFx80-ObuN92_cNcUfGjPqWJiQ@mail.gmail.com>
References: <1330383533-20711-1-git-send-email-ssouhlal@FreeBSD.org>
	<1330383533-20711-3-git-send-email-ssouhlal@FreeBSD.org>
	<4F4D2459.3010908@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:x-system-of-record;
        bh=vQkYFYWTfkKYi9rAOr1oH/nqMGOGvKwXqY5LIIhL6Cs=;
        b=c/7DMnQSFpSATBs/ID53JMd+N+rZv7is25cSi60ekhbtmf6Q2M6kjRVosFHPlGKHlU
         zTS+sj8Rt2IqDsmsX84/vk/2GiMhDqwaYFsCZWC/omCHKZ9jWCcWymw+a2yHXIlDK4qp
         p4JSIDnwbqZJXZ2jBjs7LO0YZss2J3gM8P3TDn6j5UYTusYwLsqjfh9bsudKCGwm0g8t
         2Uf5+h06S5gxWNsm2lJcLemG7ZtY7cFTFAN3sQJdCvHnmOcMQsRJ90u/zG6/xIhQ6oZm
         tMDaAHYHEasOBV+sRVKVQ+u5PT1Ut7WgbVeeZiM0Me8d12SlsGXgp1e86IRvKar8V/Qm
         tu9g==
In-Reply-To: <4F4D2459.3010908-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: Suleiman Souhlal <ssouhlal-h+KGxgPPiopAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org

On Tue, Feb 28, 2012 at 11:00 AM, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org> wrote:
> On 02/27/2012 07:58 PM, Suleiman Souhlal wrote:
>>
>> A later patch will also use this to move the accounting to the root
>> cgroup.
>>
>
> Suleiman,
>
> Did you do any measurements to figure out how long does it take, average,
> for dangling caches to go away ? Under memory pressure, let's say

Unfortunately, I don't have any such measurements, other than a very artificial:

# mkdir /dev/cgroup/memory/c
# echo 1073741824 > /dev/cgroup/memory/c/memory.limit_in_bytes
# sync && echo 3 > /proc/sys/vm/drop_caches
# echo $$ > /dev/cgroup/memory/c/tasks
# find / > /dev/null
# grep '(c)' /proc/slabinfo | wc -l
42
# echo $$ > /dev/cgroup/memory/tasks
# rmdir /dev/cgroup/memory/c
# grep '(c)dead' /proc/slabinfo | wc -l
42
# sleep 60 && sync && for i in `seq 1 1000`; do echo 3 >
/proc/sys/vm/drop_caches ; done
# grep '(c)dead' /proc/slabinfo | wc -l
6
# sleep 60 && grep '(c)dead' /proc/slabinfo | wc -l
5
# sleep 60 && grep '(c)dead' /proc/slabinfo | wc -l
5

(Note that this is without any per-memcg shrinking patch applied. With
shrinking, things will be a bit better, because deleting the cgroup
will force the dentries to get shrunk.)

Some of these dead caches may take a long time to go away, but we
haven't found them to be a problem for us, so far.

-- Suleiman
