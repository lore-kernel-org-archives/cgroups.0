From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHSET] kernfs, cgroup: make kernfs_path*() and
 cgroup_path*() behave in strlcpy() style
Date: Wed, 10 Aug 2016 11:25:09 -0400
Message-ID: <20160810152505.GK25053@mtj.duckdns.org>
References: <1470720204-4605-1-git-send-email-tj@kernel.org>
 <20160809081819.GB10279@kroah.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=G57awYJsaG8+GdYeQmYotk1z/Vgw8t8BqOK8SLuVQ2M=;
        b=kBYh008rAOfsVgRzroyB/nJaahx45+kyMaqNZNknN985lXwJpboDU8VvbiEN/novJJ
         7pLFf0Jt4mYrjPqM4CuAtef3OypKWQW6j53z8uA97EZ1KBIwuSY8W72MLMgZ4t1htoXs
         zaaFq3J2Tg12F1BDSIPp/uFw685bzDR84yC5QRGMew4qWPlhqmp9a7MFita3UA4ddmEd
         SvWyqu/kNdz3j7Sc92zHPnU39conWsFjaYE3ynvj1Gs+4fmvuEUtAPzkmNiSCzP5iDLD
         IU/q1u0FpzNgM2a8NUZfx5jGUDr4ryW1pwQvvR3A1woY/BF8St67u158QvhKqw2cRxtx
         5mfQ==
Content-Disposition: inline
In-Reply-To: <20160809081819.GB10279-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

On Tue, Aug 09, 2016 at 10:18:19AM +0200, Greg KH wrote:
> On Tue, Aug 09, 2016 at 01:23:20AM -0400, Tejun Heo wrote:
> > kernfs path formatting functions always return the length of full path
> > but the content of the output buffer is undefined when the length is
> > longer than the provided buffer.  Most cgroup path formatting
> > functions return the start of the output or NULL on errors including
> > overflow.  These inconsistent and rather peculiar behaviors developed
> > over time and make these functions unnecessarily difficult to use.
> > This patchset updates the formatting functions so that they all behave
> > in the style of strlcpy().
> > 
> > Greg, these changes are used by cgroup tracepoint additions and
> > shouldn't affect other users much.  Would it be okay to route these
> > through the cgroup tree?
> > 
> >  0001-kernfs-add-dummy-implementation-of-kernfs_path_from_.patch
> >  0002-kernfs-make-kernfs_path-behave-in-the-style-of-strlc.patch
> >  0003-kernfs-remove-kernfs_path_len.patch
> >  0004-cgroup-make-cgroup_path-and-friends-behave-in-the-st.patch
> > 
> > The patches are also available in the following git branch.
> > 
> >  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-kernfs_path-strlcpy
> > 
> > diffstat follows.  Thanks.
> 
> It's fine with me if you take these yourself:
> 
> Acked-by: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>

Applied 1-4 to cgroup/for-4.9.

Thanks.

-- 
tejun
