From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup.h: remove some functions that are now gone
Date: Tue, 14 May 2013 11:51:20 -0700
Message-ID: <20130514185120.GR6795@mtj.dyndns.org>
References: <20130503232659.GA12008@kroah.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:date:from:to:cc:subject:message-id:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        bh=bXBD+N9dwIaDP5vTTgjWjxvkgS5qfurWxfq0lOw9DXc=;
        b=FQkr28Wizifoi4Hm4e++gmsVSYwWEAnjsEw4MsNF/DI7pDFpON5IUvt9K3wKvz5TGM
         SgvsmfkQNAzn0ROosOhj9Tw90Clq6ToADmgIZV/ZnOSW2LUFmb4WJfOtQOZfi6l9MonF
         ibmvUeBKPkZsOEJ9alDmloQFlHWuvuAGUgKTFYMonEbkAn9cTFORg8DJiRnh8bYgYZu+
         /PQOwK8PJhrhYj7lDgji8qZOIzqQqCoXFFSE8MLeFVG5hO9w6Qi3gjF5LKIWuDasmo11
         GwS51uwXw5WozrHHuxKEOB+CqnQTLtE/aUDlmCsvyizUrdBeU167jYSw8tTFiIaaZ3zI
         Fs9A==
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

Applied to cgroup/for-3.11.

Thanks.

-- 
tejun
