From: Tejun Heo <tj@kernel.org>
Subject: Re: [Patch v3 0/2] cgroup: New misc cgroup controller
Date: Sun, 7 Mar 2021 07:48:40 -0500
Message-ID: <YETLqGIw1GekWdYK@slm.duckdns.org>
References: <20210304231946.2766648-1-vipinsh@google.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Sh8Gq3xXPV8r6pCBgU3qRZ/zv3llBCo/ukoG7YI1B6o=;
        b=W1llN+mC69wsu46WFlBMoFXcOnmVr7w0NFEv8x9AJaKgTSImmeCGxTwulSESANzMZb
         5QrRLyXhWRLdMn3gd1w7hSGEjUbXmxrPBJhCpf4ux983dCPe45FS6mktIWQisPQhK9Tq
         NLveo8d3ow+mrKYvQ3/lYmyhm6XFWaI62Se/mDoLeEQxG1pEq/xvPZroRcaQI8iRPw45
         OCAfkJvZelYLqfG/lrbAps9A4zLtFQBb/iUebqGE129kI3dXK+o6bcV2UoCZUlLFIYDP
         xGMCNUzTC2uJraLOZlHmOfbCc+uflS6Vi+SrfcoEJHdcKiM3w5V7v/WrAO1Rw+XJL31t
         P8yw==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20210304231946.2766648-1-vipinsh@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vipin Sharma <vipinsh@google.com>
Cc: mkoutny@suse.com, rdunlap@infradead.org, thomas.lendacky@amd.com, brijesh.singh@amd.com, jon.grimm@amd.com, eric.vantassell@amd.com, pbonzini@redhat.com, hannes@cmpxchg.org, frankja@linux.ibm.com, borntraeger@de.ibm.com, corbet@lwn.net, seanjc@google.com, vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com, gingell@google.com, rientjes@google.com, dionnaglaze@google.com, kvm@vger.kernel.org, x86@kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

Hello,

On Thu, Mar 04, 2021 at 03:19:44PM -0800, Vipin Sharma wrote:
> This patch series is creating a new misc cgroup controller for limiting
> and tracking of resources which are not abstract like other cgroup
> controllers.
> 
> This controller was initially proposed as encryption_id but after
> the feedbacks, it is now changed to misc cgroup.
> https://lore.kernel.org/lkml/20210108012846.4134815-2-vipinsh@google.com/

Vipin, thank you very much for your persistence and patience. The patchset
looks good to me. Michal, as you've been reviewing the series, can you
please take another look and ack them if you don't find anything
objectionable?

-- 
tejun
