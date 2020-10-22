From: Gabriel Krisman Bertazi <krisman-ZGY8ohtN/8qB+jHODAdFcQ@public.gmane.org>
Subject: Re: [PATCH v2 1/2] blk-cgroup: Fix memleak on error path
Date: Thu, 22 Oct 2020 16:59:39 -0400
Message-ID: <87k0vi0yf8.fsf@collabora.com>
References: <20201022205758.1739430-1-krisman@collabora.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20201022205758.1739430-1-krisman-ZGY8ohtN/8qB+jHODAdFcQ@public.gmane.org> (Gabriel Krisman
        Bertazi's message of "Thu, 22 Oct 2020 16:57:57 -0400")
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, khazhy-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, kernel-ZGY8ohtN/8qB+jHODAdFcQ@public.gmane.org

Gabriel Krisman Bertazi <krisman-ZGY8ohtN/8qB+jHODAdFcQ@public.gmane.org> writes:

> If new_blkg allocation raced with blk_policy change and
> blkg_lookup_check fails, new_blkg is leaked.

hm, sorry for the duplicate, the first attempt my script tripped on the
cover letter for some reason. Please disregard this one.

-- 
Gabriel Krisman Bertazi
