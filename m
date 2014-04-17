From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup: Use more current logging style
Date: Thu, 17 Apr 2014 15:14:16 -0400
Message-ID: <20140417191416.GS15326@htj.dyndns.org>
References: <1397748555-6647-1-git-send-email-nasa4836@gmail.com>
	<20140417153800.GO15326@htj.dyndns.org>
	<1397757955.3104.11.camel@joe-AO725>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20120113;
	h=sender:date:from:to:cc:subject:message-id:references:mime-version
	:content-type:content-disposition:in-reply-to:user-agent;
	bh=Jia53C3qkUd/Qm+HJjcXXEBe7l476MZHl9lGfAd9H50=;
	b=FfUmTJ5F5A4SMvrN79JRHoJiEJkgOggQMKO9EojHk6QYCeK1l1mSSeM9eOvnttq7yz
	Nmvu6TSGCWHCGxSOmmXyRjlvxUoj+u1xRlBmIYPpHdWs8g/nWmrc7T0SHsCAlXo/xwhq
	PmPmOwismJBG2BhfySIsM3zPj6+SzzTGmmH4lOinSXnUEc3ynp4PNt6Jgl5ugTWu+xpo
	72vhxZYCdT+ILCo9z4zZB73Fc4dYVJuR6dCMjQ5esBEs72c5DOVRDdtRr9oAoU1RGzLA
	PKYeotAlMRwePtRW+Fr9EvQ6Cfl3D+74UBRzHV4ElT42FY4WdnXGRQcETQCIkV5iDDIP
	/9Mg==
Content-Disposition: inline
In-Reply-To: <1397757955.3104.11.camel@joe-AO725>
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
To: Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, Jianyu Zhan <nasa4836-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Apr 17, 2014 at 11:05:55AM -0700, Joe Perches wrote:
> Use pr_fmt and remove embedded prefixes.
> Realign modified multi-line statements to open parenthesis.
> Convert embedded function name to "%s: ", __func__
> 
> Signed-off-by: Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>

Rolled into the series.  Will be applied after Jianyu's patch.

Thanks.

-- 
tejun
