From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHSET] cgroup: allow dropping RCU read lock while iterating
Date: Tue, 21 May 2013 12:20:45 +0900
Message-ID: <20130521032045.GA1222@mtj.dyndns.org>
References: <1369101025-28335-1-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=M2Nal0htqkqr1UJOyMk1wPCE+k5QwzHCg1WJkIXVJ4I=;
        b=w3qD5T6yDKbkg1Xm75ttp3Rg8VxjgVH4oGzOhXFLdJqA8Sg/O3+2gOiSthblfEA40z
         iLIRitJeA2G2iD5bxliD7nrhWSaZTWfvwTCWXLOCHGFsYdkHAAwjf0S6+58Zza5fL6hi
         UyyWEfeFHCtY4lg6Gp1LjY+ML0er3dKKHYXpxFDnW5wccn4B69H9r3gA6Y6mjWlKJ7oP
         jcmvK1VvAz+nlcw7DEcTPyXPyCpztYAAwwUWqKhaZAax99qXY0McNCNG9INT9S+pOxGx
         xetNDHDOLGNeE2OToLwDx+Do6qwKXSZBSeU4xVj40qFzuzVkaT+hOGJuy0EQjHn1ONq3
         gb1w==
Content-Disposition: inline
In-Reply-To: <1369101025-28335-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
Cc: containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org

(oops, used Serge's old address, using the new canonical one)

Serge, the original thread can be read from

 http://thread.gmane.org/gmane.linux.kernel.containers/26037

Li, the cpuset patchset you posted a couple weeks ago should be able
to make use of this, right?

Thanks.

-- 
tejun
