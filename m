From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup: fail if monitored file and event_control are in
 different cgroup
Date: Mon, 18 Feb 2013 09:32:18 -0800
Message-ID: <20130218173218.GH17414@htj.dyndns.org>
References: <5121C68F.1000309@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:date:from:to:cc:subject:message-id:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        bh=Fr0B1OtdelMeb/wVgrxSMiVoFTBK28OiL586/Im7wFc=;
        b=vPfFfR4KkYjaPU01og3/BImg1v2rxEzMqFJfxX2+np/AqOFRyPlCtfc5J927ljKt53
         jPCucyibbh3v7mffPoXO2yTB2Zuu6kVTdOzTF5z96nGRTxRnQDcqjUYtQF70zw3wH0Wd
         7D9ysA3MJIvpsL88lrrAnPzZxs2I2Kfx35oNvcVP+NS8RzVt7hoa3cTfLKwh8swiBIbj
         8vffg1t/OjMterlE2vFlQLPCI3NyQeQn9OqBs6NqXvVa4TfY8Z2FB5OylqRkwO+pTNdY
         QudrEqSchbN4Wb4sRwn8cqZHR4+5CpZna+ze5EjPtZu283zJm/MZQMYRitj/1a5V5s/Y
         04Rw==
Content-Disposition: inline
In-Reply-To: <5121C68F.1000309-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Mon, Feb 18, 2013 at 02:13:35PM +0800, Li Zefan wrote:
> If we pass fd of memory.usage_in_bytes of cgroup A to cgroup.event_control
> of cgroup B, then we won't get memory usage notification from A but B!
> 
> What's worse, if A and B are in different mount hierarchy, we'll end up
> accessing NULL pointer!
> 
> Disallow this kind of invalid usage.
> 
> Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Applied to cgroup/for-3.9.

Thanks.

-- 
tejun
