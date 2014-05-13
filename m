From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 cgroup/for-3.15-fixes 1/2] cgroup: introduce
 task_css_is_root()
Date: Tue, 13 May 2014 11:35:44 -0400
Message-ID: <20140513153544.GH23710@htj.dyndns.org>
References: <20140505223557.GU11231@htj.dyndns.org>
 <20140507130627.GA16702@htj.dyndns.org>
 <20140508013206.GA2797@htj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=2EQbeGmg9ppE774G6ADUGt5fHbzr5HGNlfbPQKhA1EA=;
        b=q867wZDR3fkLxizVLPYVmNyKqPyDfskwaq1XLcKUWnOXsMM8CH/EF23tKaU+GGUMwG
         9Wsq5vOwmQH5bIgNO6ECVFFpImWcRNwGi6fc9X9RvqKlh2C4mtcvcCnZMM8h5S3w38tY
         lv/jgTGHEt6O4oFnvQ5+zTClcF1uG5AtKkCxBa1gvPgXqRfFPIH7UxuKuBNGoKLpkX9O
         SnffZeb+OY76FsuLCO8Vcvt2xoIjW54sE1auTuUH3+i+i+l5rGROlxvnuttgpQQImL2/
         0yUEn6W4gcWBDcFEemqw0L+zVfXv9ebA45olLS5Ud3dzmpFrPnUry6NAWQefdOUri+z4
         CNoA==
Content-Disposition: inline
In-Reply-To: <20140508013206.GA2797-Gd/HAXX7CRxy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, May 07, 2014 at 09:32:06PM -0400, Tejun Heo wrote:
> On Wed, May 07, 2014 at 09:06:27AM -0400, Tejun Heo wrote:
> > Determining the css of a task usually requires RCU read lock as that's
> > the only thing which keeps the returned css accessible till its
> > reference is acquired; however, testing whether a task belongs to the
> > root can be performed without dereferencing the returned css by
> > comparing the returned pointer against the root one in init_css_set[]
> > which never changes.
> > 
> > Implement task_css_is_root() which can be invoked in any context.
> > This will be used by the scheduled cgroup_freezer change.
> > 
> > v2: cgroup no longer supports modular controllers.  No need to export
> >     init_css_set.  Pointed out by Li.
> > 
> > Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> 
> Applied 1-2 to cgroup/for-3.15-fixes.

Oops, mistakenly applied these to for-3.16.  Reverted and moved them
to for-3.15-fixes.  for-3.16 is rebased but the relevant content stays
the same as it pulls in for-3.15-fixes.

Thanks.

-- 
tejun
