From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 8/8] memcg: generate file modified notifications on
 "memory.events"
Date: Mon, 17 Aug 2015 15:51:08 -0400
Message-ID: <20150817195108.GD21075@mtj.duckdns.org>
References: <1439315889-3492-1-git-send-email-tj@kernel.org>
 <1439315889-3492-9-git-send-email-tj@kernel.org>
 <20150811180236.GE23408@mtj.duckdns.org>
 <20150817143056.GE10894@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=0a3GqJRN9c2tn2B9nIaorCVmEPzxbAQaUhR466uJeg8=;
        b=MbCeecHMFzviXFTfAqvGWLQ1mzRGzI28C8T5Pp+YC0zxQjn8Y/kC5C18w85GGkO3/A
         Z0I+O4UWKhvIf4q/O0rieHHAROjtH7u43fREI9QvzVBgesafc6p7xH8a3DJGtKZLRb17
         5/kkBitbHVJ4jVjBWwotI54guYJM0N0dQGUL2/nnPsBN0OXvkKqm3Ml28TMDfIhSYmLv
         INed/DM4VQlVC1N1hyNypGy+P5b7UBYsFxlL+Sj/N0AVxXmGMZg8z+21bR7OX8fiMSEa
         8P5V9RMcrtWtsnlrdEgoBZ4/nNyWVTv/iI8loH36ZTB7CD0GIUCxGCOzN2gqfG0154Zk
         Wc8A==
Content-Disposition: inline
In-Reply-To: <20150817143056.GE10894-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello, Michal.

On Mon, Aug 17, 2015 at 04:30:57PM +0200, Michal Hocko wrote:
> I cannot say I would be fond of the offset logic but whatever suits the
> cgroup core...

I don't particularly like it either but couldn't think of anything
prettier. :(

Thanks.

-- 
tejun
