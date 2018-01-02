From: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Subject: Re: cgroups(7): documenting cgroup.stat
Date: Tue, 2 Jan 2018 21:57:33 +0000
Message-ID: <20180102215726.GA2606@castle>
References: <196c0cca-b573-8c65-2b5f-66376f79a836@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 content-transfer-encoding : in-reply-to; s=facebook;
 bh=3+1X9mnndx9+oVhCHiSfbaebIiYoIXK6vcz/xamKB8w=;
 b=cvB89ilIep8KRHFt/dZrMbcEVjpZyGQg45vUs4uqnmd2xrgyvGpP6C66xb+X61zW2jqE
 8cQyC9lJl5QM5uabV1dAmiBXcmpRQGYNBhGa9AZlwm5NMCs74UIr38GQucEslrl1P5G/
 Iw/Q7V91B46BtH6OJonlSViyWMtoqr3exE0= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=3+1X9mnndx9+oVhCHiSfbaebIiYoIXK6vcz/xamKB8w=;
 b=a4rq8ykeRF3lsjWAX3xT7mj8AxbocLB1uXaqu6WC73pqCSi2uw3FzV4ZOSiJX+iRTmQpE6q7HyYj6RF8Lm5Df/HVSlHYqBJU3k/+MaPO79dpZe9FQqp1F30GeU/3jqaOGUX9TVIC0xBWLy1z4UKDywoPAencPo6x/apUSi9/gzs=
Content-Disposition: inline
In-Reply-To: <196c0cca-b573-8c65-2b5f-66376f79a836-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
To: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-man <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hello, Michael!

Thank you for working on this!

Please, find my comments below.

On Tue, Jan 02, 2018 at 07:22:33PM +0100, Michael Kerrisk (man-pages) wrote:
> Hello Roman,
> 
> I wish to add documentation to cgroups(7) for the cgroup.stat file
> that you added in Linux 4.14. I wrote some text based on your text
> added to the cgroup-v2.txt file, but added some pieces, and also have
> a question (see below). The plain-text version for (easy review)
> is shown below. Could you please review this text? (Please note 
> the FIXME!)
> 
> The branch containing the pending cgroups(7) changes can be found at :
> https://git.kernel.org/pub/scm/docs/man-pages/man-pages.git/log/?h=draft_cgroup_updates
> 
> [[
>    Cgroups v2 cgroup.stat file
>        Each   cgroup   in   the  v2  hierarchy  contains  a  read-only
>        cgroup.stat file (first introduced in Linux 4.14) that consists
>        of  lines  containing key-value pairs.  The following keys cur‐
>        rently appear in this file:
> 
>        nr_descendants
>               This is the  total  number  of  visible  (i.e.,  living)
>               descendant cgroups underneath this cgroup.
> 
>               ┌─────────────────────────────────────────────────────┐
>               │FIXME                                                │
>               ├─────────────────────────────────────────────────────┤
>               │For  the  following text on nr_dying_descendants, it │
>               │would I think be  helpful  to  describe  a  condrete │
>               │example of when one might see nr_dying_descendants a │
>               │nonzero value for this  key.  Ideally,  the  example │
>               │would be one that the reader could easily reproduce. │
>               │Is there such an example?                            │
>               └─────────────────────────────────────────────────────┘

Hm, basically any cgroup which had some pagecache, associated during the
lifetime, will spend some time in the dying state. This means that for
most cgroups this number will be non-zero for some amount of time,
which depends on global memory pressure.
It's also very implementation-defined, and will be likely changed
in the following kernel versions.

So, I'm not sure, that such an example will be useful for a user.
Until this number is huge and constantly growing, it shouldn't be
interesting for an user at all.

> 
>        nr_dying_descendants
>               This is the total number  of  dying  descendant  cgroups
>               underneath this cgroup.  A cgroup enters the dying state
>               after being deleted.  It remains in that  state  for  an
>               undefined  period  (which  will  depend  on system load)
>               before being destroyed.
> 
>               A process can't be made a member of a dying cgroup,  and
>               a dying cgroup can't be brought back to life.

So, maybe it worth it to add a statement, that some amount of dying cgroups
is normal and it's not a signal of any problem?

Otherwise looks very good to me.

Thank you!

Roman
--
To unsubscribe from this list: send the line "unsubscribe linux-man" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
