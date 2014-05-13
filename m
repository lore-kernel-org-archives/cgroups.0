From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHSET cgroup/for-3.16] cgroup: implement cftype->write()
Date: Tue, 13 May 2014 12:17:01 -0400
Message-ID: <20140513161701.GA1866@htj.dyndns.org>
References: <1399380266-3324-1-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=i7MKOKyducOl+H3ALdVocNOmwCGdzFkhnEmYXXW77Qk=;
        b=NdParrM2y9hFhTY5QpY8rkZMOiUvQ8u+TxlJgj2TPfZKj3SJlvVnGSKZI9mj+pR9WF
         in73vFWknCz21kqyo9WKdVA1Ctfn1ORpVlM38f7wKQ8vhksc4FCaeALQN2SdMik93+Hv
         eH/V/vB44rnCf824QEK3hmm7tSm/fMPVIRjwnFpU/WiFhWjp2oAmk6DzB/T3YgPh52s9
         yFm7ujt9yyqJJkIATYphrM6IQP0zrraNlTT9Z6Krd6e0o0gu6j345u+6eABehGEO5u7G
         PAYXiA3IrmiGTPP0KztRd6OzRAVhQCZvvjazPe8P++TDwajyyFzU8sRzy83FQBQ28HRm
         LgNw==
Content-Disposition: inline
In-Reply-To: <1399380266-3324-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, arozansk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org

On Tue, May 06, 2014 at 08:44:21AM -0400, Tejun Heo wrote:
> Hello,
> 
> This patchset implements a new cftype operation ->write() and replace
> ->write_string() and ->trigger() with it.  ->write() is similar to
> ->write_string() but maps directly to the kernfs write operation and
> has access to all available context information including the
> associated kernfs_open_file, which will make things like implementing
> kernfs active protection manipulation easier.
> 
> ->write_string() becomes redundant and ->trigger() has always been
> spurious.  This patch replaces all users of the two methods to
> ->write() and remove them.
> 
> This patchset contains the following five patches.
> 
>  0001-cgroup-implement-cftype-write.patch
>  0002-cgroup-replace-cftype-write_string-with-cftype-write.patch
>  0003-cgroup-replace-cftype-trigger-with-cftype-write.patch
>  0004-cgroup-convert-tasks-and-cgroup.procs-handle-to-use-.patch
>  0005-cgroup-remove-cgroup-control_kn.patch

Applied to cgroup/for-3.16.

Thanks.

-- 
tejun
