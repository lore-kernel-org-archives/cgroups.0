From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH RFC 0/2] add nproc cgroup subsystem
Date: Fri, 27 Feb 2015 16:49:04 -0500
Message-ID: <20150227214904.GQ3964@htj.duckdns.org>
References: <1424660891-12719-1-git-send-email-cyphar@cyphar.com>
 <20150227114940.GB3964@htj.duckdns.org>
 <54F09E62.8000007@gmail.com>
 <20150227170640.GK3964@htj.duckdns.org>
 <CAAAKZwtDS+MNd3wTheGUrNVbP7qLX_u3vo+YDOAbsU-Rq=Ot2w@mail.gmail.com>
 <20150227174503.GM3964@htj.duckdns.org>
 <CAAAKZwvuR2X7EEZz+UWRCGYajaJQ+VzXYfDEq6EQnssv9+6FJQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=4HXyMZuxSSHSa4Th/jFY4WzIW/AqJDPMSSOHAjAnqsA=;
        b=G61LJ8m37wlc4hG9MUXEM4dVUtt+J2+zYl/VBNlcwZAKBGoRcm8Th6JknxpKzrcCMd
         W2rhUx1hu/g2FqRWredbx/JDpDHuDsksAQyfwJsTxnLfVBEoPC/zm7ZMbDjvvwv57r5s
         LrRR27PiMVhD4p20sEoIik7LcNyov9xIKEcE5X5mCtf46XSCLXJ9C+KYCMxYJD3jfEUN
         EiIBVMRSRt8USWayZIia5vjswGlPYxrp59EfOMXne/zf8QMeYzG+30I2FLOBfcPPqMsn
         NrCwPe4qacsDvZ9uyoAfN+GLg1ulYHfV/UyZ/HDlfmeFZIfq2uP/50hF0WIVIym/I/VV
         AUSA==
Content-Disposition: inline
In-Reply-To: <CAAAKZwvuR2X7EEZz+UWRCGYajaJQ+VzXYfDEq6EQnssv9+6FJQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tim Hockin <thockin@hockin.org>
Cc: Austin S Hemmelgarn <ahferroin7@gmail.com>, Aleksa Sarai <cyphar@cyphar.com>, Li Zefan <lizefan@huawei.com>, mingo <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, richard <richard@nod.at>, =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>

On Fri, Feb 27, 2015 at 01:45:09PM -0800, Tim Hockin wrote:
> Are you willing to put a drop-dead date on it?  If we don't have
> kmemcg working well enough to _actually_ bound PID usage and FD usage
> by, say, June 1st, will you then accept a patch to this effect?  If
> the answer is no, then I have zero faith that it's coming any time
> soon - I heard this 2 years ago.  I believed you then.

Tim, cut this bullshit.  That's not how kernel development works.
Contribute to techincal discussion or shut it.  I'm really getting
tired of your whining without any useful substance.

> I see further downthread that you said you'll think about it.  Thank
> you.  Just because our use cases are not normal does not mean we're
> not valid :)

And can you even see why that made progress?

-- 
tejun
