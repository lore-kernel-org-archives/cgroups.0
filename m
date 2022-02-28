From: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Subject: Re: [syzbot] linux-next test error: WARNING in
 __mod_memcg_lruvec_state
Date: Mon, 28 Feb 2022 12:06:19 +0100
Message-ID: <YhysqzlMHWTXLR4B@linutronix.de>
References: <000000000000c7fde605d8e6b085@google.com>
 <20220227220943.490fb7b5f7c57d872f9523cb@linux-foundation.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1646046380;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kuYSAt1MZUM/puwk3yZe7khsCEtHcjgvevbbDPW87Zk=;
        b=LhXrKps5NOhICMcZKstR1+jE06JIFDHGjkMlKSATJoZgFQyZ8pK2n5VWwZri6sGMljWH9g
        6WLE0k08QFMolOr516NBCQZ3vGUTVimY6xVTLdEBJfTOf3VGOPv7gAxHMMCyqYysM97V8+
        18+EXOf5bzfsoi9/qExuIC+mncp8HDV30K23ZwWHfDtnjmRQaEHjcBAH+8cCHOcP2MtfLz
        W6DFUWJjy97Y+hOwOPzo9IyuYGt/GXbD9CYsWZkHYTED/5c+aRyYszrRFpxO+nUkwD5RLq
        Ic2vobdPqB8lalkJ6UbsRkbK8vqOFoTLuQTiwxvJXmZ0RqFKM266ujgKTUYCrw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1646046380;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kuYSAt1MZUM/puwk3yZe7khsCEtHcjgvevbbDPW87Zk=;
        b=iBu5w7qyoK/y+oosN2Cvtf8iwCsNS0eYQ8x4WLqriihNBzWDKhtLPmKfRL/IkcMYx1cZ4G
        vqvOGjGC4TnBxNAA==
Content-Disposition: inline
In-Reply-To: <20220227220943.490fb7b5f7c57d872f9523cb-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: syzbot <syzbot+a526c269335f529d25c8-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-next-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org, syzkaller-bugs-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org

#syz test: git://git.kernel.org/pub/scm/linux/kernel/git/bigeasy/staging.git 71d365035711aef4c4b1018d02fcf7868e3cb0c5

On 2022-02-27 22:09:43 [-0800], Andrew Morton wrote:
> (cc bigeasy)
> 
>                         WARN_ON_ONCE(!irqs_disabled());
> 
> in __mod_memcg_lruvec_state(), methinks.

This report ist from before you added
   mm-memcg-protect-per-cpu-counter-by-disabling-preemption-on-preempt_rt-where-needed-fix.patch

to your tree. So it can be ignored. The next -next tree should be fine.

Sebastian
