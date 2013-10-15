From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: cgroup_attach_task && while_each_thread (Was: cgroup attach task
 - slogging cpu)
Date: Tue, 15 Oct 2013 09:34:10 -0400
Message-ID: <20131015133410.GE3141@htj.dyndns.org>
References: <20131004130207.GA9338@redhat.com>
 <20131007184507.GD27396@htj.dyndns.org>
 <20131008145833.GA15600@redhat.com>
 <5254EB2A.7090803@huawei.com>
 <20131009133047.GA12414@redhat.com>
 <20131009140551.GA15849@redhat.com>
 <20131009165448.GA22437@redhat.com>
 <5257F9E3.5030708@huawei.com>
 <20131011160004.GA26416@redhat.com>
 <CALPf4Ty_xmred_Mf=tyzKDLu+rqStYUxTazZpYDOCKN_nm-5vQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=86VMsFoMqhomM7UNd7MJ7MgmMTTft0rs9YBuOL5lvU8=;
        b=h1SHsVI73dt7v1lEDds2ZasnELK35/FIiFoFoLW133qa/FlqRhJZS/Yp+rZfVQGswC
         fmH0lHMQrmLVz/uc83YEUmXGl0F2nOKPJw8ZvfzqG2eR4OX2GXi0kEglGi5ZKWxZ0Eu6
         qMRNloeDZIAkRNWLLmKQOkknmxzStedPkcmFhlsbyHKjx2Ho/r0ziSwgRLO20PdEun2i
         93+d4kisgvZCQ65cV2Rkbo1WXdkavnAMe/14IyAWCwi0Y+mYRlDKCgqYa4OoTOvGzYcE
         hJR2WYTk0IlYhmjj+69o+jd5LGDhtysZEn4qntPfy1414PSv02PgaXPujM1YedA8ayxr
         3YoQ==
Content-Disposition: inline
In-Reply-To: <CALPf4Ty_xmred_Mf=tyzKDLu+rqStYUxTazZpYDOCKN_nm-5vQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: anjana vk <anjanvk12-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, eunki_kim-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org

On Tue, Oct 15, 2013 at 10:34:04AM +0530, anjana vk wrote:
> Hi All,
> 
> Thankyou for your suggestions.
> I have made the modifications as suggested.

I already applied the version Li posted (as you the author, of course).

Thanks a lot!

-- 
tejun
