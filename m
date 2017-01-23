From: Ma Shimiao <mashimiao.fnst-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Subject: Re: questions about cgroup devices
Date: Mon, 23 Jan 2017 15:51:52 +0800
Message-ID: <d55afb9b-5f20-0f82-027b-d83947980879@cn.fujitsu.com>
References: <d28bc963-4936-6574-c606-d2b0c475f0c9@cn.fujitsu.com>
 <5885B245.2030901@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5885B245.2030901-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On 01/23/2017 03:35 PM, Zefan Li wrote:
> It's not a bug. It's a feature introduced by commit ad676077a2ae4af4bb.

Oh, got it.
> That said, I don't like this feature at all, because it's very confusing,
> and obviously you are confused.

Yes, I am really confused about this.

And, another problem is I can't allow/deny all devices.

# echo a > /sys/fs/cgroup/devices/test/devices.deny 
-bash: echo: write error: Invalid argument
# echo a > /sys/fs/cgroup/devices/test/devices.allow
-bash: echo: write error: Invalid argument

Is this also a new feature?


-- 
Ma Shimiao
Development Dept.I
Nanjing Fujitsu Nanda Software Tech. Co., Ltd.(FNST)

