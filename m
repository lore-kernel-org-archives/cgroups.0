From: Dongsheng Yang <dongsheng081251-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cgroup: Enable controllers for default hierarchy by default.
Date: Mon, 25 Aug 2014 22:56:22 +0800
Message-ID: <CA+qeAOrabPcat8t9vwkeN7QZ0-DQ4F_uzeW5WRs6DyranEGzyg@mail.gmail.com>
References: <1408966052-2076-1-git-send-email-yangds.fnst@cn.fujitsu.com>
	<20140825144009.GB31066@mtj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=Gt4yTjnExH2JETrKKc5Chn0JL0jly7XCjHpizldna/k=;
        b=j6o97gQ6nZcG1P1YhjnqobgU3U0KZH5OBX/2zsAC7onZcKz9b0VV1izq1yckmaxhus
         2qNolGyOnP2H6jg3R9VyYdGBsHc2K/2mwmpyxccOD8cyyfjlbfhdLl85vJhiB+iKwErJ
         ZLtIEfmGXTHY1m3fVm4OX8EH2w0jVXqkacf23rpk5nO8Oa+mW7/7XdCImkngH5/QREOv
         aeLq3ZvBtm4H5Cio8/3CtWr88Qj2LeiK6NzrsvGAyNNMMbkU+GxTYmnPpQdgwZTkAUFY
         frCOe/ygcvDd8qBDSbeSnZ2N5Wb6aTYMSzBvH/TGxFk43XYs+wCKS8LovuilSzfKaHZ6
         NkPQ==
In-Reply-To: <20140825144009.GB31066-9pTldWuhBndy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Dongsheng Yang <yangds.fnst-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi tj,

On Mon, Aug 25, 2014 at 10:40 PM, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> Hello, Dongsheng.
>
> On Mon, Aug 25, 2014 at 07:27:32PM +0800, Dongsheng Yang wrote:
>> When we create a cgroup in unified hierarchy, we have to enable
>> controllers in cgrp_dfl_root.subtree_control manually. From
>> my practice, I did not find the benefit we disable controllers
>> in cgrp_dfl_root by default.
>
> Hehe, I actually enjoyed the frankness.  No fudging around, basically
> just "I used it for a bit and it didn't feel useful to me".
>
>> As I am a newbie to cgroup, please correct me if I am wrong.
>
> I don't think being new to cgroup is important here.  Regardless of
> the specific area, you should be able to build and argue the
> rationales for the changes you propose.  This is important because not
> only the changes need to be justified but also the process will help
> you actually think about and analyze the changes that you're
> proposing.  If you can't build strong enough rationales for a given
> change, it probably shouldn't be proposed.
>
> Here, your rationale is nothing more than "I played with it 5 mins and
> it seemed weird to me".  There was no effort in understanding the
> overall design, use cases or implications.  You're just driving by
> shooting random patches expecting other people to do what you should
> have done before submitting the patches.  If you want to change the
> behavior, please first study and think about it and ask specific
> questions when unsure.

Yes, I met something unsure in my studying. And I thought sending a
patch to show my question is an acceptable way. Sorry for that.

> Submitting basically random patches expecting
> others to argue for or against it is one of the worst ways to learn
> about a subsystem.  Please don't ever do this regardless of the
> subsystem in question.

Shame on me and sorry for troubling you. I really have some questions in
my study, but I should not post them via a patch.

I need more reading and thinking.
If finally I can't answer my question by myself or google.
Then I will ask you experts.

Thanx
>
> Nacked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
>
> Thanks.
>
> --
> tejun
> --
> To unsubscribe from this list: send the line "unsubscribe cgroups" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
