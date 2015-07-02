From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 40/51] writeback: make bdi_start_background_writeback()
 take bdi_writeback instead of backing_dev_info
Date: Wed, 1 Jul 2015 22:29:46 -0400
Message-ID: <20150702022946.GJ26440@mtj.duckdns.org>
References: <1432329245-5844-1-git-send-email-tj@kernel.org>
 <1432329245-5844-41-git-send-email-tj@kernel.org>
 <20150701075009.GA7252@quack.suse.cz>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=z0MtdWpPXhSbC6Y3Ar8nUb+jzW5RuqNRvAJ7steZPY8=;
        b=rQpZ+svSVbwg8ozXCGtJPtx5B1XRlngTtuElafaWW8EAam+l5Bj3rVWCqIRWg5BVpu
         OphwqjDhplXM01r0nU5ZmClEYCPlAzh+pTVrwwta7WSxLAKtnWDRIJjF/8npCpxcO9ta
         qCIR+kMhvfblu44Mtu8v5vN6MEQzBligJXuzRgGyfZt1z4mFVrGxpYtifbWqSYPvM3pR
         WejXDsQhhLUVO+mqWr6ZBzP2MfxfAwhWAIo0jeuiocmJLq7Ddy3jYJK6rjPJRnd6oH/B
         0F30m9farDuWQ1bARaPO6xy8sD7JEP0wn048FZk7dy/4bbRvdeBqRBAChRtH6cF3BKo1
         C6kw==
Content-Disposition: inline
In-Reply-To: <20150701075009.GA7252@quack.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jan Kara <jack@suse.cz>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, hch@infradead.org, hannes@cmpxchg.org, linux-fsdevel@vger.kernel.org, vgoyal@redhat.com, lizefan@huawei.com, cgroups@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.cz, clm@fb.com, fengguang.wu@intel.com, david@fromorbit.com, gthelen@google.com, khlebnikov@yandex-team.ru

On Wed, Jul 01, 2015 at 09:50:09AM +0200, Jan Kara wrote:
> Can we add a memcg id of the wb to the tracepoint please? Because just bdi
> needn't be enough when debugging stuff...

Sure, will add cgroup path to identify the actual wb.  css IDs aren't
visible to userland.

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
