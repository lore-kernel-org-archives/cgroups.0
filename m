From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHSET block/for-linus] writeback: cgroup writeback fixes
Date: Tue, 29 Sep 2015 12:50:20 -0400
Message-ID: <20150929165020.GA3578@mtj.duckdns.org>
References: <1443545274-18787-1-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=4ARUVbhTuj3bzFr+/L8MPEAHciPywBj6D2KZUi1cEsQ=;
        b=VYQ/jWW/6jJf3h6+QjoIlR1GKkFBthfj7CDg0eUzRSPFQNPiHY5Y7N8msTjZkfb0hU
         PLK1NrqXyKKJhHHR9Alyip/Ia1GcJZQYVoaEYDJ++5VWrztHCZyWCzPsMzNBsAAH2jYX
         tPJdsb3FWti0K/YPvOiVHnR6rQKROnHi2PXb5MvQPjJC28amD98t9L8XcubIgK5XBrT0
         zsCR5DjNT2kziVkygwdNKw90LXD7X3QyFQefBScBoj8AUXZ4Ywd+K2nqvg214Q4Hjt6y
         p625HMWTpIp0VQwdWwgGFvINc9D86lFS0Issu2R+RhG+EKAI7SiEVy/GOcHY9zU6IUu9
         WaMQ==
Content-Disposition: inline
In-Reply-To: <1443545274-18787-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: jack-IBi9RG/b67k@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tytso-3s7WtUTddSA@public.gmane.org, dedekind1-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, decui-0li6OtcxBFHby3iVrkZq2A@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org

Oops, forgot Jan.  Jan, this thread contains five patches fixing bugs
in cgroup writeback support.

 http://lkml.kernel.org/g/1443545274-18787-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org

Thanks.

-- 
tejun
