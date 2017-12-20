From: Rouven Czerwinski <rouven-FCEtQH5z4SoXQnBnI9m10w@public.gmane.org>
Subject: Re: [PATCH cgroup/for-4.15-fixes] cgroup: fix css_task_iter crash on CSS_TASK_ITER_PROC
Date: Wed, 20 Dec 2017 23:42:25 +0100
Message-ID: <874lolja26.fsf@czerwinskis.de>
References: <39625861-99c0-1c15-08a6-49b9d678c4c2@redhat.com> <20171213152914.GN3919388@devbig577.frc2.facebook.com> <121dc065-89ba-98ab-68ff-e86f1a636b06@redhat.com> <20171213213756.GX3919388@devbig577.frc2.facebook.com> <20171220151331.GA3413940@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=czerwinskis.de;
        s=mail; t=1513809747;
        bh=OStUoDXb4WIvDp15EE6C8FNgeN+Hwsc2XXsK1Ixvz6k=;
        h=References:From:To:Cc:Subject:In-reply-to:Date:From;
        b=dEr33XBS+3rUy6CZHjTMI4A/H/+0sY7Hn8YhbAL8SwOgjPahCF5VwGe/Cqc1EX5Wx
         NC4ZQCKFyRvzhSa+Y0tNRuA79DUh9VDY6ltkqk6ZICd+8IWLQ8jeAlgC1MuaVtVUJj
         RmIUIUKKsF4kfcCvbUmXUCjAU8WjuWmDZNbeoRec=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=czerwinskis.de;
        s=mail; t=1513809746;
        bh=OStUoDXb4WIvDp15EE6C8FNgeN+Hwsc2XXsK1Ixvz6k=;
        h=References:From:To:Cc:Subject:In-reply-to:Date:From;
        b=bpUFWFnuCgoLqfhFojOH6xVkt0PH+EPs5FqPIYx0Yx6Ioo+8BT/z67rFEKKFHtHWN
         +16ZENfE+FEuxRIyWkHCwk7MwJqZwzS9/lCph3rua1TrRyBx3lmn1qxa42ljk2aZAX
         5rJGoGNcjEIOt0kX6cIVnN5w/YmpYgJAKIfPqaes=
In-reply-to: <20171220151331.GA3413940-4dN5La/x3IkLX0oZNxdnEQ2O0Ztt9esIQQ4Iyu8u01E@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Laura Abbott <labbott-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, regressions-rCxcAJFjeRkk+I/owrrOrA@public.gmane.org, Bronek Kozicki <brok-CgwIDsGnGWjby3iVrkZq2A@public.gmane.org>, George Amanakis <gamanakis-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>


Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> writes:

> Hello,
>
> Applied the following to cgroup/for-4.15-fixes.  Will push out to
> linus later this week.  I could reproduce the problem reliably and am
> pretty sure this is the right fix but I'd greatly appreciate if you
> guys can confirm the fix too.

Fixed here as well, 4.14.8 stable with your fix on top.

Thanks,
Rouven
