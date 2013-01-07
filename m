From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHSET] cpuset: drop cpuset->stack_list and ->parent, take#2
Date: Mon, 7 Jan 2013 08:47:07 -0800
Message-ID: <20130107164707.GI3926@htj.dyndns.org>
References: <1357249446-25075-1-git-send-email-tj@kernel.org>
	<50E94392.2050509@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20120113;
	h=x-received:sender:date:from:to:cc:subject:message-id:references
	:mime-version:content-type:content-disposition:in-reply-to
	:user-agent; bh=+1mGlHjOVn6h/L/hbKnOrMHyBKOH4pZnad1ovAIArZM=;
	b=GYp3npIUYOTzz/7/b+/RjVG3/GrK3kqCRAR0tgzT0Of+9OgOEYL2cmCTaqlnVo0SYx
	5QzL4SjjHJjSwzmstKdV6pxmIXQZ2Ot9LBD6X3bSez1KK1CaDXdIRHQbd2air4dVgEDY
	KgCUNaT61ccZf6BD9iIuIEHwPGdYcihy+RdaomfbP9fFGDhtOK17QRJSVqx11jIVYRQH
	RxzyNO+6IIo/ZwffqfjGGFXVb8FWl4WbxB0LpgDLu12lEG7jlv4suYXDQ0sxtqBHkAXt
	UAhG7ThoBvSkB6a8Ty+XzYrMo7F4/28Edw4AtmTMnz6tPnxSCECGIU7jnlb+f7gcYYSj
	EJNw==
Content-Disposition: inline
In-Reply-To: <50E94392.2050509-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
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
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: paul-inf54ven1CmVyaH7bEyXVA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org

On Sun, Jan 06, 2013 at 05:27:46PM +0800, Li Zefan wrote:
> Acked-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

I'll route this together with "decouple cpuset locking" patchset in a
separate branch in cgroup tree.  If anyone objects, please let me
know.

Thanks.

-- 
tejun
