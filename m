From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/1] freezer: exec should clear PF_NOFREEZE along with
	PF_KTHREAD
Date: Thu, 25 Oct 2012 10:37:31 -0700
Message-ID: <CAOS58YPAVVr=itauGD9eTpfRLSBLuM8Bpyuq9AP73MDr8dPmiQ@mail.gmail.com>
References: <1350426526-14254-1-git-send-email-tj@kernel.org>
	<1350426526-14254-5-git-send-email-tj@kernel.org>
	<20121022183453.GA24687@redhat.com>
	<20121022211822.GF5951@atj.dyndns.org>
	<20121023155533.GC16201@redhat.com>
	<20121024190651.GC12182@atj.dyndns.org>
	<20121025171236.GA6776@redhat.com>
	<20121025171256.GB6776@redhat.com>
	<20121025172016.GF11442@htj.dyndns.org>
	<20121025173756.GB7650@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20120113;
	h=mime-version:sender:in-reply-to:references:date
	:x-google-sender-auth:message-id:subject:from:to:cc:content-type;
	bh=VgZPvYTwdXW5d1qaaomT7cH2so0xgwDUAZRE7+gujc0=;
	b=cLg1ieEkyAnTst1z2TNnKJixc9gHEXJD/Qp9zvKmyoJYZwfW1CBJyktllrNQPfuDWz
	EoTXwSg1NJpqNMY24XZuEfO3A9DLe9RW+7a9MLxeWnXGEMXssHVOaefMngu8Pok33J18
	M+O7p4AuyjCn/ISWGDvJ1i8Wkuo3bj3Ik3ntEX5f4iFYKCugd2HIJBjxubALyVSfJC/z
	66OiXJspQwS7sel9dbMNgUW6L0++B8jKfN6LEN3jvRXj/3FXcJNeD3R4nVtKeb0O+Pwy
	j1ydOQWoaYJcNFcExnFGIs97ddhN4eVjOqP+x63LeDXwyNl3r/Zf6PBYqxRGys2vTmsb
	ydZg==
In-Reply-To: <20121025173756.GB7650-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>, 
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, rjw-KKrjLPT3xs0@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

Hello,

On Thu, Oct 25, 2012 at 10:37 AM, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>> How should this be routed?  -mm?  Andrew, can you please pick this up?
>
> or perhaps Rafael can take it?

Yeah, that works too.  Rafael?

-- 
tejun
