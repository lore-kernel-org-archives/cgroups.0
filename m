From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: cgroup: avoid attaching a cgroup root to two different
 superblocks
Date: Tue, 18 Apr 2017 15:39:27 +0900
Message-ID: <20170418063927.GA3899@wtj.duckdns.org>
References: <58E7532B.4030505@huawei.com>
 <20170414232737.GC20350@outlook.office365.com>
 <20170414233233.GA8183@outlook.office365.com>
 <58F49BE2.8080200@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=FjdDlfgd7SujriRtwVQvbodQuBR47cAvYeAvF6BH2h0=;
        b=CvqWR5P7c2tYfnsqpJbZ6e1L5gImkUt6oIKzZkwMnJPhGxE8tx9sqtTfbB7lJ8YwlH
         T7PDHC1ui6LGUaPgnOhk/ov8tTb5qtb3sV3QkMlc+crvTAhgwVFGh8aaal+ubcP1y7lP
         FAxd3Xxtw1yHksKMAJZcj7832hzz+o+ABFcT9XeOpv8FLmlAVvx5fwvD8TI/1UVJ9Vcg
         eztsBrmlXD9EQXe0P1MQ8/cXAYqiyVsNpA9nGsQWna2RXyaSnRIr5WpssFGVWtSYQxOe
         W7WhbdA/lZiJEJLADhrSFYje/+I5PkG+x9NrBVrFqItsK/IHNC3DWIv+Vnc7qCsWnfMB
         /sQA==
Content-Disposition: inline
In-Reply-To: <58F49BE2.8080200-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Andrei Vagin <avagin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, dvyukov-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hello, Li.

On Mon, Apr 17, 2017 at 06:41:38PM +0800, Zefan Li wrote:
> Now I remember why it didn't check NULL pointer... Could you try the following fix?
> It also reverts my previous patch. I would appreciate if you run the full test suit,
> to make sure it won't break anything.

Can you please refresh the patch on top of cgroup/for-next which
already has the original patch reverted?  Let's apply this one for
for-4.12 w/o -stable.  The bug isn't too likely to trigger in the wild
and the fix is kinda subtle.  If necessary, we can last ask Greg to
pick it up once we know that the patch is safe.

> PS: Tejun, I found recently I can no longer receive your emails. Don't know why...

Hah, no idea.  I didn't change anything on my side - all emails are
sent through gmail.com.

Thanks.

-- 
tejun
