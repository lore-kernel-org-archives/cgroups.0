From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 5/8] kernfs: define kernfs_node_dentry
Date: Wed, 23 Dec 2015 11:25:15 -0500
Message-ID: <20151223162515.GI5003@mtj.duckdns.org>
References: <1450844609-9194-1-git-send-email-serge.hallyn@ubuntu.com>
 <1450844609-9194-6-git-send-email-serge.hallyn@ubuntu.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=iujFO13Wco5c/HXRaWoHuJIpZ5pPprVYtt+CY8uMLc0=;
        b=u3VwPTmVGFqdunrl7bCiSjpR5aF13A8cRyzo3workqaDkvahDIoADi4/qbdjgofIzo
         TZ9hwnWeo1AyIozFdf0vmHR+Xaxel21/kBZ2+HD0kj32Mm1P+5KQ+ebbqRatjK+zEUWJ
         K+FAtWNQvBvXPZNGqyzEgce9s4QolMW2mLvH0uGEZaTQ3u/Hjf+MKBjMC/+93+a4y3gg
         Cuq3duafZVAa8Cq2yq4azTvypQBaVZiS1mQFMjwJVJIY7YHJDbfobh9/RxAhIhu4Gbi1
         6ZI0s0rt6QrQhoB90OEyxacNyuhQD5FGUQSsC5/x463yuZIwDRvm7uAynXgRge+t+HPz
         b+cg==
Content-Disposition: inline
In-Reply-To: <1450844609-9194-6-git-send-email-serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lxc-devel-cunTk1MwBs9qMoObBWhMNEqPaTDuhLve2LY78lusg7I@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, "Serge E. Hallyn" <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>

On Tue, Dec 22, 2015 at 10:23:26PM -0600, serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org wrote:
> From: Aditya Kali <adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> 
> Add a new kernfs api is added to lookup the dentry for a particular
> kernfs path.
> 
> Signed-off-by: Aditya Kali <adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Serge E. Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>

Greg, this is the other kernfs change in the series.  Can I route this
through the cgroup tree with other changes?

Thanks.

-- 
tejun
