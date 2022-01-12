From: Eric Biggers <ebiggers@kernel.org>
Subject: Re: [PATCH v3 1/1] psi: Fix uaf issue when psi trigger is destroyed
 while being polled
Date: Tue, 11 Jan 2022 22:46:06 -0800
Message-ID: <Yd55LpWuuKHm26L2@sol.localdomain>
References: <20220111232309.1786347-1-surenb@google.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641969968;
        bh=4Tn/USo8KXboTynK6KqLOmV0gnZLDsBgsgeyLJRL42U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KPBg50AG2faZ8N/dkKJzcmsW0yf4+tZqhCuQn+FFCR6kc2LkIgOS6StWmkVzv0WOT
         xBb+gILh/BDRFnnrCnrG/CF9hRYe/34tqdNvlFZU3P0bKcCIdBtaF0Ekhip3FZOHnU
         4ax4ZDl2jRoPJwOQj1iZWfUaFrDbOJYSdFps7gUK/HcmyKUFRRZT4f7K1qcJ972sxI
         15MLR5c/BlgsMvRDUIaIAV5KAg8KdDk3AhV0oOxKh2c9EcN0K7cTgCEkwKog49VHPh
         +R6aYIPs+srU9pWbkDcZK3xM5tibGLjp9mkmdZm5/dMBbfOSjEhf1e48Yvr3Berhn6
         JJJh+q5HmRWVA==
Content-Disposition: inline
In-Reply-To: <20220111232309.1786347-1-surenb@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Suren Baghdasaryan <surenb@google.com>
Cc: hannes@cmpxchg.org, torvalds@linux-foundation.org, tj@kernel.org, lizefan.x@bytedance.com, mingo@redhat.com, peterz@infradead.org, juri.lelli@redhat.com, vincent.guittot@linaro.org, dietmar.eggemann@arm.com, rostedt@goodmis.org, bsegall@google.com, mgorman@suse.de, bristot@redhat.com, corbet@lwn.net, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, stable@vger.kernel.org, kernel-team@android.com, syzbot+cdb5dd11c97cc532efad@syzkaller.appspotmail.com

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
> ---

Looks good,

Reviewed-by: Eric Biggers <ebiggers@google.com>

- Eric
