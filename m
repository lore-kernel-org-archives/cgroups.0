From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [RFC][PATCH v2 04/31] timers: block: Use del_timer_shutdown()
 before freeing timer
Date: Fri, 28 Oct 2022 01:26:03 -0700
Message-ID: <Y1uSG/7VXWLNlxlt@infradead.org>
References: <20221027150525.753064657@goodmis.org>
 <20221027150925.819019339@goodmis.org>
 <20221027111944.39b3a80c@gandalf.local.home>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=NSFvNasYsfodbnQHojzQMqo+zVFJLt7KLaSOZRcfaUo=; b=bLdfCKmpWHGIaP8dtWXbmk1azY
        3V0CcnTEZ27fcVNfDAzAhxdGG6lCTYWqzDmOVPnITxvO0hCyl8rkNg9dxNDb6IONIHt9A+wKFX92j
        g0ATxvMYQFh+6Vok1Bf8jOatYALAROFElh6U0OgBkVX0ndqLN0OAinRgSP7pc7Lu0n6RVkFvVaJJd
        zkbjIteUfej7HyCW1IBZOHVxKQvszSJslt4MFRLD7jgRuAGPZNvE9pm28BdJErSjA0PFCf0YVWDJH
        aF2edsB8E5AgzWYZscjS97W5BB3RTGGW7Mg8S/IlAPTb/r+cyw6G2WJFKMWka94flyzU0aqCBS9Do
        4m3xz2cw==;
Content-Disposition: inline
In-Reply-To: <20221027111944.39b3a80c-f9ZlEuEWxVcJvu8Pb33WZ0EMvNT87kid@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Stephen Boyd <sboyd-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Guenter Roeck <linux-0h96xk9xTtrk1uMJSBkQmQ@public.gmane.org>, Philipp Reisner <philipp.reisner-63ez5xqkn6DQT0dZR+AlfA@public.gmane.org>, Lars Ellenberg <lars.ellenberg-63ez5xqkn6DQT0dZR+AlfA@public.gmane.org>, Christoph =?iso-8859-1?Q?B=F6hmwalder?= <christoph.boehmwalder-63ez5xqkn6DQT0dZR+AlfA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

This is just a single patch out of apparently 31, which claims that
something that doesn't even exist in mainline must be used without any
explanation.  How do you expect anyone to be able to review it?
