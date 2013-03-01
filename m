From: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Subject: Re: [PATCH 2/3] cgroup: add cgroup_name() API
Date: Fri, 1 Mar 2013 20:39:17 +0000
Message-ID: <20130301203917.GT4503@ZenIV.linux.org.uk>
References: <512B01FA.5020506@huawei.com>
 <512B020D.9040504@huawei.com>
 <20130226022703.GA13837@htj.dyndns.org>
 <512C8D84.7090707@huawei.com>
 <CAOS58YMb7HRQ3X+Z92vi3+jKr4DuNmAgxtc5e3Jkhy-s-7Os-g@mail.gmail.com>
 <512DE4A8.5050303@huawei.com>
 <CAOS58YMhm6Uia0bx6oUHwheXUhu8i31LPhh8VVggvg0vg-UmUQ@mail.gmail.com>
 <512EFEDF.8080205@huawei.com>
 <CAOS58YMBcvhfBWdQmt=JersRgB9nVgsrLACtLovz===2ZXfR=w@mail.gmail.com>
 <51304C6D.8050207@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <51304C6D.8050207-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Fri, Mar 01, 2013 at 02:36:29PM +0800, Li Zefan wrote:
> On 2013/2/28 22:49, Tejun Heo wrote:
> > On Wed, Feb 27, 2013 at 10:53 PM, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org> wrote:
> >>> static const struct cgroup_name root_cgroup_name = { .name = "/" };
> >>
> >> Can't... That's char name[0] not char *name.
> > 
> > Flexible array members can be statically initialized. If you wanna be
> > really anal about it, you can do it manually with a wrapping struct
> > but I don't think that would be necessary.
> > 
> 
> I didn't know this difference between flexible array and zero-size array.
> Thanks.

Mind you, initializing flex array member is explicitly invalid per C99;
it's a GNU extension...
