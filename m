From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v4 0/3] Send audit/procinfo/cgroup data in socket-level
	control message
Date: Wed, 15 Jan 2014 18:23:45 -0500
Message-ID: <20140115232345.GA22237@mtj.dyndns.org>
References: <1377614400-27122-1-git-send-email-jkaluza@redhat.com>
	<1389600109-30739-1-git-send-email-jkaluza@redhat.com>
	<20140115.121730.1984913330507219167.davem@davemloft.net>
	<1389828103.681.34.camel@flatline.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20120113;
	h=sender:date:from:to:cc:subject:message-id:references:mime-version
	:content-type:content-disposition:in-reply-to:user-agent;
	bh=1i1WBu3FmMpSgBLVy1lTrKZFH/X2wryN7gZfbCFv+r4=;
	b=dlLR8OtinlmVvdOslzBSJLh+AnkokSEV8LlODQGsDn29kKDHGNHIS3yzql3dK4wksQ
	nm4qm0RBIrM2KMVMJUhwJAnVYogj0WM8MzyV8vNnLF0EebUmv8GFAIzfKEo91bZbVmnc
	p52mL4qnG+dl+OIv7ExT1Ew+3H3JZUa/BsvcPgV2MikMMPvzmPpk+CZwQswY3tqD1ADV
	grHc9kkeF37Lq0zM0juOmgfuxApODxfmV0gb5UO0CvRCp60U1DdOWN+uqPABb7djpAF3
	23FYq43OlqOuI4OubE07ktqW7Dp3udg+XOwOsHpLywZhHBcJgXx/O3ns+GpJh+gvEIGl
	A6lg==
Content-Disposition: inline
In-Reply-To: <1389828103.681.34.camel-OjZBOOqb7SR7cYLChsl7DafLeoKvNuZc@public.gmane.org>
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
To: Eric Paris <eparis-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: jkaluza-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, rgb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>

On Wed, Jan 15, 2014 at 06:21:43PM -0500, Eric Paris wrote:
> Reliably being able to audit what process requested an action is
> extremely useful.  And I like the audit patch, as it is a couple of ints
> we are storing.
> 
> procinfo and cgroup can both be up to 4k of data.
> 
> Is there an alternative he should consider?  Some way to grab a
> reference on task_struct and just attach that to the message?

Or maybe it can be made separately optional instead of tagging along
on an existing option so that it doesn't tax use cases which don't
care about the new stuff?

Thanks.

-- 
tejun
