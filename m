From: Li Zefan <lizefan@huawei.com>
Subject: Re: [PATCH 2/3] cgroup: add cgroup_name() API
Date: Fri, 1 Mar 2013 14:36:29 +0800
Message-ID: <51304C6D.8050207@huawei.com>
References: <512B01FA.5020506@huawei.com> <512B020D.9040504@huawei.com> <20130226022703.GA13837@htj.dyndns.org> <512C8D84.7090707@huawei.com> <CAOS58YMb7HRQ3X+Z92vi3+jKr4DuNmAgxtc5e3Jkhy-s-7Os-g@mail.gmail.com> <512DE4A8.5050303@huawei.com> <CAOS58YMhm6Uia0bx6oUHwheXUhu8i31LPhh8VVggvg0vg-UmUQ@mail.gmail.com> <512EFEDF.8080205@huawei.com> <CAOS58YMBcvhfBWdQmt=JersRgB9nVgsrLACtLovz===2ZXfR=w@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAOS58YMBcvhfBWdQmt=JersRgB9nVgsrLACtLovz===2ZXfR=w@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>

On 2013/2/28 22:49, Tejun Heo wrote:
> On Wed, Feb 27, 2013 at 10:53 PM, Li Zefan <lizefan@huawei.com> wrote:
>>> static const struct cgroup_name root_cgroup_name = { .name = "/" };
>>
>> Can't... That's char name[0] not char *name.
> 
> Flexible array members can be statically initialized. If you wanna be
> really anal about it, you can do it manually with a wrapping struct
> but I don't think that would be necessary.
> 

I didn't know this difference between flexible array and zero-size array.
Thanks.
