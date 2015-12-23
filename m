From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/8] kernfs: Add API to generate relative kernfs path
Date: Wed, 23 Dec 2015 11:24:33 -0500
Message-ID: <20151223162433.GH5003@mtj.duckdns.org>
References: <1450844609-9194-1-git-send-email-serge.hallyn@ubuntu.com>
 <1450844609-9194-2-git-send-email-serge.hallyn@ubuntu.com>
Mime-Version: 1.0
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=K+B9MGeNEjIUtB0Flpg4SXCZWoeu1RHIk3I04q7cnIY=;
        b=biXiL1LZNLRr9r9uhh4Mkdj0TMuUyL67avLPPrjwYjS8gVF9WbuX9u5SX2tRLYpl/y
         UrbrLM2xl33DMWIRQa5Qu4Ak9aSm2yFxNQCvNJYVmotmGjMYv7BM7qxurT4Hh/AlzIyK
         cpdDfO4FJQXchw0pdZOyn+34PPuHmyLxkPk0wGNJFLEfc3iFZHg37gb0BclD18gsx5aY
         l5DNL6hpWz878ggq04PAJg9I22abFn8wlmHU2DGSzF3tv2vI+6tIcT8wT65OzkOklNCg
         tUYzzaW0kb9lPAN6JyKeWonCWFaYpjWDx06AMFZava8vO6cDlA1A22LIgITMYZxUzeyG
         MmgQ==
Content-Disposition: inline
In-Reply-To: <1450844609-9194-2-git-send-email-serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lxc-devel-cunTk1MwBs9qMoObBWhMNEqPaTDuhLve2LY78lusg7I@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, "Serge E. Hallyn" <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>

On Tue, Dec 22, 2015 at 10:23:22PM -0600, serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org wrote:
> From: Aditya Kali <adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> 
> The new function kernfs_path_from_node() generates and returns kernfs
> path of a given kernfs_node relative to a given parent kernfs_node.
> 
> Signed-off-by: Aditya Kali <adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Serge E. Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>

Greg, can I route this together with other changes?

Thanks.

-- 
tejun
