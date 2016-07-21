From: Miklos Szeredi <mszeredi-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v4 18/21] fuse: Add support for pid namespaces
Date: Thu, 21 Jul 2016 09:25:17 +0200
Message-ID: <CAOssrKfJrQuf_exBVGtn-EBOBnRhhNWe+2P=VkEqtp3qmGYiFA@mail.gmail.com>
References: <1461699396-33000-1-git-send-email-seth.forshee@canonical.com>
 <1461699396-33000-19-git-send-email-seth.forshee@canonical.com>
 <CA+2rt426_pshAauQizcxkfAq16vmEpB4sJ4genW_ucosH3j=zQ@mail.gmail.com> <20160720125201.GA52079@ubuntu-hedt>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160720125201.GA52079@ubuntu-hedt>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Cc: Sheng Yang <sheng-bA7cAZRAfhAdnm+yROfE0A@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Miklos Szeredi <miklos-sUDqSbJrdHQHWmgEVkV9KA@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Richard Weinberger <richard.weinberger-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Austin S Hemmelgarn <ahferroin7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Pavel Tikhomirov <ptikhomirov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, kernel list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, fuse-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Jul 20, 2016 at 2:52 PM, Seth Forshee
<seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org> wrote:

> It sounds like we need to remove the restriction on accessing the
> filesystem from a different pid namespace. I don't think this poses a
> security problem. However there's no pid mapping that is usable by the
> userspace fuse process, so what do we put in the fuse request? Probably
> the only candidates are 0 and 0xffffffff.
>
> So a question for the fuse developers - is one value or the other
> preferrable for fuse_in_header.pid when the pid cannot be mapped, and is
> this going to cause problems for any fuse filesystems? I suspect that
> few filesystems actually look at the pid anyway, and already for a
> filesystem mounted in a pid namespace the values being given to
> userspace won't be correct for the namespace of the fuse process.

pid = 0 sounds good.

The pid from the request is used for example to get the auxiliary
group list by libfuse (fuse_req_getgroups()).   That's not used by all
filesystems and it will return an error in case it can't find the proc
entry (which it won't for pid == 0).

It would be nice if we could transfer the group list through the
userspace/kernel protocol, since then it wouldn't depend on proc and
on being in the same pid namespace.  But that's another story.

Thanks,
Miklos
