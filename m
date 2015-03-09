From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v4 0/2] cgroup: add pids subsystem
Date: Sun, 8 Mar 2015 23:08:38 -0400
Message-ID: <20150309030838.GD13283@htj.duckdns.org>
References: <1424660891-12719-1-git-send-email-cyphar@cyphar.com>
 <1425606357-6337-1-git-send-email-cyphar@cyphar.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=yuapleBpcnWOb+HO2b3QU8Wb8oPh0UJT99gahEz6n48=;
        b=UAPu5EoTzEi4G7O67c5QJ5cnsnsmb1L90nNtLHdwOZ+CsPsXBXnNLAYLxtq6ithxIU
         wlsf3vleR5aiOIVIW/IdpeFvK+jk4pdH4o620fiK0y09DiMfNckirUvxdvwzrrtUSA1U
         BEt3eeQwJGFhHfGwf2RaPfn8AesU0qJKLKF9zz++KtwY8kqnJ2JbgdMiwksCoKqPgQaq
         LgsVG2I7es19SjrulCSqvKtnVuDTEopiH6ocAJyfRLHckLA6jQr8f7PSN74aX+BtiMg6
         htc12zg7bfD/JZzDsGFbQhwxdGKFdGyEiDABpiirV75+r7K+yREUe7eOiY7z+QVza1XP
         e/sA==
Content-Disposition: inline
In-Reply-To: <1425606357-6337-1-git-send-email-cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, richard-/L3Ra7n9ekc@public.gmane.org, fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, Mar 06, 2015 at 12:45:55PM +1100, Aleksa Sarai wrote:
> This is a checkpatch'd version of the pids patchset[1]. It fixes some
> style problems, as well as switch to using need_canfork_callback inside
> kernel/cgroup.c. Also remove the dependency on PAGE_COUNTER (because
> pids now uses an internal hierarchical counter) in Kconfig.

Oops... reviewed the wrong patches.  Can you please not chain
different versions of the patchset?

Thanks.

-- 
tejun
