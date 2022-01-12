From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v2 1/1] psi: Fix uaf issue when psi trigger is destroyed
 while being polled
Date: Wed, 12 Jan 2022 09:37:10 -0500
Message-ID: <Yd7nlpb5C1asdT9p@cmpxchg.org>
References: <20220111071212.1210124-1-surenb@google.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=gN6nYxQ+pi+EX1rhDvVBrSftakRyc+dgBWa+b+GYGOw=;
        b=mUYM4mY5CMZFdZf8LoZxSmr2HrBtGWy/OuRuqq61O/YzMtji9cyv80GCzVs3+/yBQM
         ea8h1TgnQuxezzPUpv+dYIPkHwYXJi8s8RLc3/qoVBJIdyMcJhSjmxQmUkiMYq3Ma/mk
         FCYSRjNlYgSsNDINKB5/QzVJm37I8VUcYMKVK1npArHn3Q6M8h3+azxH7i00hNJ3x5GH
         /MOIqnam32dgIasH341bE3XTjvVfDKCVLNSfwExXT1QlmErmH+Ao3P6BgqP5XnvYn4WD
         4jkB6eQQ2fqopSlJvC4a/kF34giBDtsHPoVyc1PJ8OLUBC1+AAZopBx4/zXrVog6uTYo
         wZRg==
Content-Disposition: inline
In-Reply-To: <20220111071212.1210124-1-surenb@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Suren Baghdasaryan <surenb@google.com>
Cc: torvalds@linux-foundation.org, ebiggers@kernel.org, tj@kernel.org, lizefan.x@bytedance.com, mingo@redhat.com, peterz@infradead.org, juri.lelli@redhat.com, vincent.guittot@linaro.org, dietmar.eggemann@arm.com, rostedt@goodmis.org, bsegall@google.com, mgorman@suse.de, bristot@redhat.com, corbet@lwn.net, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, stable@vger.kernel.org, kernel-team@android.com, syzbot+cdb5dd11c97cc532efad@syzkaller.appspotmail.com

On Mon, Jan 10, 2022 at 11:12:12PM -0800, Suren Baghdasaryan wrote:
> With write operation on psi files replacing old trigger with a new one,
> the lifetime of its waitqueue is totally arbitrary. Overwriting an
> existing trigger causes its waitqueue to be freed and pending poll()
> will stumble on trigger->event_wait which was destroyed.
> Fix this by disallowing to redefine an existing psi trigger. If a write
> operation is used on a file descriptor with an already existing psi
> trigger, the operation will fail with EBUSY error.
> Also bypass a check for psi_disabled in the psi_trigger_destroy as the
> flag can be flipped after the trigger is created, leading to a memory
> leak.
> 
> Fixes: 0e94682b73bf ("psi: introduce psi monitor")
> Cc: stable@vger.kernel.org
> Reported-by: syzbot+cdb5dd11c97cc532efad@syzkaller.appspotmail.com
> Analyzed-by: Eric Biggers <ebiggers@kernel.org>
> Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>

That looks good to me, thanks Suren.

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

Peter, would you mind picking this up and routing this to Linus
through the sched tree, please?
