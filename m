From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH cgroup/for-6.1] cgroup: Make cgroup_get_from_id() prettier
Date: Wed, 28 Sep 2022 13:38:52 +0200
Message-ID: <YzQyTJVyG9LVUAp7@blackbook>
References: <20220923115119.2035603-1-ming.lei@redhat.com>
 <Yy3tEKSV+vg6swOd@slm.duckdns.org>
 <Yy3tjvIGd2j4wnSw@slm.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1664365133; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=pYWIjI2zG6qx8PsHipWo2k/Bj8E69alY2jmp4fMvkIs=;
        b=eEu5aM3Q2HILLqqyiC30YRVrS5v1Z9lVjKfTJGXvx5Yt6gAGhiY0jYQMSLwApMmmUJ0ySe
        QHjPXTkEuUkOd1aZWjW6bDk0hh0xkgbmy1FM7U59KznTpM34r7dvbAtrPayJoCOy4q6yvw
        IaBQjeUZtHXa8cEXZ5xrDTEzuVPHF6Y=
Content-Disposition: inline
In-Reply-To: <Yy3tjvIGd2j4wnSw-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Ming Lei <ming.lei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Marco Patalano <mpatalan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Muneendra <muneendra.kumar-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>

On Fri, Sep 23, 2022 at 07:31:58AM -1000, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> Ming, Michal, you guys' changes to cgroup_get_from_id() combine to make
> cgroup_get_from_id() a bit too ugly, so I applied the following patch to
> cgroup/for-6.1. Please take a look and lemme know if I broke anything.

The cleanup looks good.

Just for the record, I understand the refernced fix is persisted as
> df02452f3df0 ("cgroup: cgroup_get_from_id() must check the looked-up kn is a directory")

Regards,
Michal
