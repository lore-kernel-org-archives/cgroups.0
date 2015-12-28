From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: CGroup Namespaces (v8)
Date: Mon, 28 Dec 2015 12:46:46 -0500
Message-ID: <20151228174646.GA30165@mtj.duckdns.org>
References: <1450844609-9194-1-git-send-email-serge.hallyn@ubuntu.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=EllmPb853fbfQfl9kklouglkZ3IU9qeyeJxRz06rwoI=;
        b=jtL71M9CqMEh82bedCCe2EFACEXQ6n79VreRv4WYGi2O2ZN5YMAtG+xIX/d2in1g/5
         3Enn2DbZThUr7R1W9qNqWZMoq6XpDUthr8EIswF+tt/qn4v+y0JWCaIQtAoH2CX7gDn/
         pXrEw15H6vQqqgzWZjQVee3giaU9myWpF8RbXUTn/lpjxgm/DbLoBog1+NRPyZKmUovb
         v28pQihp5SM9+bbV9XFhwe+hxvmEVnJAuXdzfXslf9kLqlkcPxRk6ag2N0b9rXjtQT7S
         2uii1ooM+vjWas0wvNoDK6oqOaGle2x1z4J0HqL5PexG33yg/b899wlnqG2G7LYFfADC
         EsxA==
Content-Disposition: inline
In-Reply-To: <1450844609-9194-1-git-send-email-serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lxc-devel-cunTk1MwBs9qMoObBWhMNEqPaTDuhLve2LY78lusg7I@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org

Applied 1-6 and 8 to cgroup/for-4.5.

Thanks.

-- 
tejun
