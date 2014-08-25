From: Dongsheng Yang <dongsheng081251-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH V2] cgroup: Introduce cgroup_detach_task().
Date: Mon, 25 Aug 2014 22:46:03 +0800
Message-ID: <CA+qeAOq7hYq-TJMh8jQpJy=nWwk2FsUMSS1Hd=-JkhLLXbweEQ@mail.gmail.com>
References: <1408966330-2374-1-git-send-email-yangds.fnst@cn.fujitsu.com>
	<20140825141220.GA31066@mtj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=36PHhOOVFG4rbXI3D2WRTkYnNzDYB/ydBCc3PPgrQU4=;
        b=hQy9ptxs+JZCArT3tEbpGUkU5VQdJZvLBdkGlVTVx4bdqmaiGuM1YC5dtYxWJnw4fq
         ZGb7hy+k14hd0jCPX2Dhnsn7pc9mOcsqeDoIJUB8Ww+g5wHLwtZfJ7rHNyBDzZrXPhqU
         LYf5l5SHIV/r1fcYCIZbgsiQjhIvhMBIUd78uYON+X2LeiuilRSZWOO/fmePdLFDWwas
         t+Tvza7Su5IUIbDtbJzu0CnZHoBxFVI2GVa3ojeuFOGqZNWdE6QtH10trP5dfv443Qk+
         0ROn8+DY1i8jHG3iuatWJdzjGTR0WZeXYNTxIZxbtoYT8joHRpz7A14aReUiYH/Dbzwf
         DtAw==
In-Reply-To: <20140825141220.GA31066-9pTldWuhBndy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Dongsheng Yang <yangds.fnst-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi tj.

On Mon, Aug 25, 2014 at 10:12 PM, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> On Mon, Aug 25, 2014 at 07:32:10PM +0800, Dongsheng Yang wrote:
>> Currently, the only method to detach a task from a cgroup is moving
>> it to others. It looks not natrual to me.
>
> Ummm... how is this different from moving it to the root cgroup?
> "just because" usually isn't a good enough rationale.
>

Thanx for your reply :).

My point here is that attaching and detaching are a pair of operations.
And the things involved in these operations should be a process
and a cgroup. But currently, when we want to detach a process from
a cgroup (A), we have to attach it to another cgroup (B). I think it is not
easy to understand. People would say: "Why I want to detach a process
from A, I have to care about another cgroup."

So I created this patch here wanting to make these operations more easy to
understand. And make attaching and detaching to be antonymous in action.

I think maybe we can use it in the Cgroup V2 which is in developing. :)

That's all my reason for this patch. But you could think it makes no sense.
It's okey to me.

Thanx

> Thanks.
>
> --
> tejun
> --
> To unsubscribe from this list: send the line "unsubscribe cgroups" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
