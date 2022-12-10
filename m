From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 1/2 block/for-6.2] blk-iolatency: Fix memory leak on
 add_disk() failures
Date: Sat, 10 Dec 2022 10:54:48 -0800
Message-ID: <CAHk-=wiw4bYT=rhA=UJD4u41Oq_uoWt1dAXpzqwQYdOtJQqYZw@mail.gmail.com>
References: <Y5TQ5gm3O4HXrXR3@slm.duckdns.org>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=jjD4ucfx+sg79aU2mhUtRUhlS74JIWv5Z/WsZ5sivF0=;
        b=BzvvoS4YZaiHtVtTnrMPkORr9QN1kyuo5edsRj1EnzCjtxaavYwgd1MdZhbSrsmMz/
         pQLt+8DKvwX5PRNY3AkuVsEXWG3TG9LNQME3xhKH5umXkHq8wRVg5p7P0UkLsc4gLlOz
         C1Wz8XlCiVSbwQEORsXQiY6twwLuti4patvKQ=
In-Reply-To: <Y5TQ5gm3O4HXrXR3@slm.duckdns.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, darklight2357@icloud.com, Josef Bacik <josef@toxicpanda.com>, cgroups@vger.kernel.org

On Sat, Dec 10, 2022 at 10:33 AM Tejun Heo <tj@kernel.org> wrote:
>
> I'm posting two patches for the iolatency memory leak issue after add_disk()
> failure. This one is the immediate fix and should be really safe. However,
> any change has risks and given that the bug being address is not critical at
> all, I still think it'd make sense to route it through 6.2-rc1 rather than
> applying directly to master for 6.1 release. So, it's tagged for the 6.2
> merge window.

Ack. I'm archiving these patches, and expect I'll be getting them the
usual ways (ie pull request).

If people expect something else (like me applying them during the
merge window as patches), holler.

            Linus
