From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v3 1/1] psi: Fix uaf issue when psi trigger is destroyed
 while being polled
Date: Wed, 12 Jan 2022 09:39:58 -0500
Message-ID: <Yd7oPlxCpnzNmFzc@cmpxchg.org>
References: <20220111232309.1786347-1-surenb@google.com>
Mime-Version: 1.0
Return-path: <stable-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=azTS6tnDk3tgwE9tswmIFeSjakmtEkN/3qV9mBsYccQ=;
        b=lTRxPpgHABlbCins2TOnLV9LVjCQ26SweG5q5/C2dMrN7f4+7+CdEQaKc4xcdS/zs3
         DnnJODvxalPzEBmfycggfJ4lZoZUdSfkcT1FFajWBuoDH4tbJJLL2YuL6VbiKPY23zjT
         s9abyL/GVEQlgdsFh47XnaBAIlnd4r3ZyvPyN5/9fVlr23f1ZQ+zFnmJ2EknoM6EVijq
         DtrWB4hpPieJhguRemvh6pArWmjvKs5iO38IbvNSIbHAERKk9TjFr3Jxk2ED+QMTUtWB
         yC+ONdLHxP7q+hbMjaRXE0DQCgYR737mTcvby6eksJwvQM1crqiY6MklMC7KIIBeXrYS
         SJPg==
Content-Disposition: inline
In-Reply-To: <20220111232309.1786347-1-surenb@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Suren Baghdasaryan <surenb@google.com>
Cc: torvalds@linux-foundation.org, ebiggers@kernel.org, tj@kernel.org, lizefan.x@bytedance.com, mingo@redhat.com, peterz@infradead.org, juri.lelli@redhat.com, vincent.guittot@linaro.org, dietmar.eggemann@arm.com, rostedt@goodmis.org, bsegall@google.com, mgorman@suse.de, bristot@redhat.com, corbet@lwn.net, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, stable@vger.kernel.org, kernel-team@android.com, syzbot+cdb5dd11c97cc532efad@syzkaller.appspotmail.com

On Tue, Jan 11, 2022 at 03:23:09PM -0800, Suren Baghdasaryan wrote:
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

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
