From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: cgroup: BUG: unable to handle kernel NULL pointer dereference
Date: Mon, 4 Jan 2016 14:17:16 -0500
Message-ID: <20160104191716.GB3807@mtj.duckdns.org>
References: <20160101234028.GA1750@hudson.localdomain>
 <20160102115437.GE3660@htj.duckdns.org>
 <20160104191553.GA21384@mail.hallyn.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=W1NQcSBbW9rcH6FBp6NbYW8VirryQa7fzV5M7qdM6no=;
        b=WjopHEvGlG0Sf1efH5dOB69XAr9HnX8vR1nE8jGIOLRyYSmu1hyf9KOq28woNFuHT4
         ARYKCIQwFUe4wMbqJW3GxLtnHzcZfx/wCT0/THQ3r/ELFFuP1kdQ+rwOTJgVdAkt2ntS
         /zdxIFzcwHtxjEIWokrtbgjAQPBDNEX75c1XCYWXJdGWDuLyIfmCNuJsNcpgv5d8aoo9
         xYbaga97HqHkcCJ6Z/5zAVOtkNvyZbuZuB3+7Zx64neh4aCdk5jVRkZXK63kMcovFmEF
         TEjLJM1ulZmPEY4M9ZAsuL0rhtomPRdDfhvaJrMin0aqAg8wXRdkPFaOMsRIIzgIUBR3
         SvAA==
Content-Disposition: inline
In-Reply-To: <20160104191553.GA21384-7LNsyQBKDXoIagZqoN9o3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Serge E. Hallyn" <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Cc: Jeremiah Mahler <jmmahler-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Happy new year, Serge.

On Mon, Jan 04, 2016 at 01:15:53PM -0600, Serge E. Hallyn wrote:
> an updated set is at https://git.kernel.org/cgit/linux/kernel/git/sergeh/linux-security.git/commit/?h=cgroupns.v9
> Would you like a new patchset send to the list, or is the github
> tree ok?

Please repost.

Thanks!

-- 
tejun
