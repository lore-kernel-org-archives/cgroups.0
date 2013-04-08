From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [Workman-devel] cgroup: status-quo and userland efforts
Date: Mon, 8 Apr 2013 11:49:51 -0700
Message-ID: <20130408184951.GK3021@htj.dyndns.org>
References: <20130406012159.GA17159@mtj.dyndns.org>
	<20130408175925.GE28292@redhat.com>
	<20130408181607.GI3021@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20120113;
	h=x-received:sender:date:from:to:cc:subject:message-id:references
	:mime-version:content-type:content-disposition:in-reply-to
	:user-agent; bh=a+27ICFrUDWEQ1OsltvyjoC6rhdXMEncjf4NEBMLWI8=;
	b=lgDfVUUPIGLYqn5DtBHGZFP0Ev+QbnSlIAqN23wyPU/WeHe8A7+/hFZM6zwQ9wUXAn
	AVxN+xuYHfn4Lkg5LdthD/P234l9nrlA3Z1vcEeTkso6CcSyHCQQx3yzdWevCU5t7QBC
	fuE2xw60lc3nhBqIciDWrHL5ImBzU4d1+S1enxTHNLZfGDI3BTFNeimM1s68ZY6Aw6gc
	14hLCipLz6Ja0Rb6ddt4SgBWeAiTG/MqB9mQ9/L/eSygnkhTOOoeioF6MKxzTIC2UPV8
	xA3tbTWQ+YqagI4RnQy/cciiJm3ouyIJTUE8vxUmftdufbYw5Mo/zqLMuvit6KNM5Q/F
	xb0A==
Content-Disposition: inline
In-Reply-To: <20130408181607.GI3021-Gd/HAXX7CRxy/B6EtB590w@public.gmane.org>
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
To: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, Kay Sievers <kay.sievers-tD+1rO4QERM@public.gmane.org>, lpoetter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dhaval.giani-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, workman-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org

On Mon, Apr 08, 2013 at 11:16:07AM -0700, Tejun Heo wrote:
> > Given the fact that library has view of full system resoruces (both
> > persistent view and active view), shouldn't we just be able to extend
> > the API to meet additional configuration or resource needs.
> 
> Maybe, I don't know.  It just looks like a weird approach to me.
> Wouldn't it make more sense to implement it as a dbus service that
> everyone talks to?  That's how our base system is structured these
> days.  Why should this be any different?

To expand a bit, the base system being composed that way makes a lot
of sense.  It becomes clear who's responsible for what and there's a
reliable way to recover when things go awry on the clients' sides.
Also, it pretty much *forces* you to design an interface which fits
the problem domain properly rather than exposing all the control knobs
there are without thinking how they'd be actually useful.  The
language binding issue is much easier too - it's already solved.

It seems like the only logical thing to do, well, at least to me.
Am I missing something?

Thanks.

-- 
tejun
