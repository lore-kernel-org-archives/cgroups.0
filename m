From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [patch v3 -mm 1/3] memcg: integrate soft reclaim tighter with
 zone shrinking code
Date: Fri, 17 May 2013 10:45:54 -0700
Message-ID: <CAOS58YP6qXM_mXvsCtGSViOZTw=mwnfUS7cZGAES8F4w5mCQdA@mail.gmail.com>
References: <1368431172-6844-1-git-send-email-mhocko@suse.cz>
	<1368431172-6844-2-git-send-email-mhocko@suse.cz>
	<20130517160247.GA10023@cmpxchg.org>
	<20130517165712.GB12632@mtj.dyndns.org>
	<b4e0e499-b922-4e9c-a0f8-02318ddf3b9b@email.android.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:x-received:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        bh=EocGuCEiGWzgXNnNen9CIMTKgmqP8xfFrgh1/iO1+D4=;
        b=L1Rp+mgHg/6DJfOLR6KHe2BeKypPmGADNbfGUPzXe5lY7jKkichzHzVbCa6Y+BH1Fj
         /VWR5Cgm2rXfECF+kwMw3K9aC1hYAeL74ahqtOqXBwjqR1z+GkpNbo9oQrrqJdl7r5TZ
         YsolSH3avOnWRyPAyAc4lI6xl8Nax4OAvfIXARhsY9kzlDuekDOccb9vTEAE9+Mlf4bm
         X1FhC346t/8h8gOnovR3d1iuAh/axWPneos8Q9vVuqEb0GPaxCDuMyqFCyzZ0d/fHnbB
         AHFQMLWa5tYOXJi7fQL/i7aALJPPAgkPUmkc8wAlUQPTSmVlX7FcVCfOKd8q/0+9tvCU
         ZVsw==
In-Reply-To: <b4e0e499-b922-4e9c-a0f8-02318ddf3b9b-2ueSQiBKiTY7tOexoI0I+QC/G2K4zDHf@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Ying Han <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Michel Lespinasse <walken-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Hello,

On Fri, May 17, 2013 at 10:27 AM, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> wrote:
>>Hmmm... if the iteration is the problem, it shouldn't be difficult to
>>build list of children which should be iterated.  Would that make it
>>acceptable?
>
> You mean, a separate structure that tracks which groups are in excess of the limit?  Like the current tree? :)

Heh, yeah, realized that after writing it but it can be something much
simpler. ie. just linked list of children with soft limit configured.

> Kidding aside, yes, that would be better, and an unsorted list would probably be enough for the global case.

Yeap.

> To support target reclaim soft limits later on, we could maybe propagate tags upwards the cgroup tree when a group is in excess so that reclaim can be smarter about which subtrees to test for soft limits and which to skip during the soft limit pass.  The no-softlimit-set-anywhere case is then only a single tag test in the root cgroup.
>
> But starting with the list would be simple enough, delete a bunch of code, come with the same performance improvements etc.

Thanks.

--
tejun
