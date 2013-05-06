From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup.h: remove some functions that are now gone
Date: Mon, 6 May 2013 12:08:23 -0700
Message-ID: <20130506190823.GC800@mtj.dyndns.org>
References: <20130503232659.GA12008@kroah.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:date:from:to:cc:subject:message-id:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        bh=pI6XyQp9BZBJ2OEPezOPydOboghZvRZiCjwKQw4BOS0=;
        b=bIUVOv89BJG+Lh3SPOUfeXEHs6+2xvb25olbz9809BtYCGQMZEWZcyRdx+wc4mpB0x
         KT08gFQW76QzWUayT11MGIs+XWJeGQpfRmFD2AWDEWQ+uv0fsh2vOTPmknoA8E5XbaBg
         c8nuTAgCq9PSFdq7ACFxnYDTV51QznDNdCuY3YxW7uxACM9vKM1b6LLBMtrN5ys7c3Xg
         3ATfoIYYY60pDD0oISgUojmzPmJ+mUmk9gicmmhZXLSYBZvrZA6HNrcGcwP2Lqk8ZOXj
         8hT1JbClOShjg5oc7mO2hWJxyhvtg2PCz62pFX+iHgoSAWMEg8oOmSkr/93t9Yos01gX
         /HXg==
Content-Disposition: inline
In-Reply-To: <20130503232659.GA12008-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, May 03, 2013 at 04:26:59PM -0700, Greg KH wrote:
> From: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
> 
> cgroup_lock() and cgroup_unlock() are now no longer exported, so fix
> cgroup.h to not declare them if CONFIG_CGROUPS is not enabled.
> 
> Signed-off-by: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>

Will apply to cgroup/for-3.11 once v3.10-rc1 drops.  Thanks!

-- 
tejun
