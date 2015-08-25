From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2] cgroup: pids: fix invalid get/put usage
Date: Tue, 25 Aug 2015 14:20:07 -0400
Message-ID: <20150825182007.GC26785@mtj.duckdns.org>
References: <1440471044-10154-1-git-send-email-cyphar@cyphar.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=twXKfXXG1UGccjCf9repEUCN2C4nbF+w7h1A66tDsgs=;
        b=yGu3uyNGFIikIMdqWCk2QdTXWe03QADbjo/e8Sk/sDKa3gSLB1vNEtQp4wok+7wNL7
         //E+HO0Dj7oJPvqGRpHBwi2lXMZCiSCQfkKcTEQO2oy7MoEIX1PB5zzBB34wVa5696VN
         MUsqdq8ULIvFamAC38dVSTN1WSdxgSnxMll+9LfvxsgaT46vTfvmufRXwrfLdB0E40ij
         IQTmFzd1fB9XizD0BIzWnZmCJXZ3Kioflb/ZZgnc51EaZCp5G38VidA1/bHn2lKYkS13
         jPTb02uFCRJTJSQDCI1gM6eLiTFetr0MQ3vlSFPtpJrIbVg1HcCesItA1CVHEc3sX5r3
         Ggeg==
Content-Disposition: inline
In-Reply-To: <1440471044-10154-1-git-send-email-cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
Cc: n.borisov-/eCPMmvKun9pLGFMi4vTTA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Aug 25, 2015 at 12:50:44PM +1000, Aleksa Sarai wrote:
> Fix incorrect usage of css_get and css_put to put a different css in
> pids_{cancel_,}attach() than the one grabbed in pids_can_attach(). This
> could lead to quite serious memory leakage (and unsafe operations on the
> putted css).
> 
> Signed-off-by: Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>

Applied to cgroup/for-4.3 w/ minor comment update.

Thanks.

-- 
tejun
