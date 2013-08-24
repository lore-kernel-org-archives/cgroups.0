From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHSET v2 cgroup/for-3.12] cgroup: make cgroup_event specific
	to memcg
Date: Sat, 24 Aug 2013 14:25:57 -0400
Message-ID: <20130824182557.GA5825@htj.dyndns.org>
References: <1376582550-12548-1-git-send-email-tj@kernel.org>
	<20130821201239.GB2436@htj.dyndns.org>
	<20130824182005.GA15897@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20120113;
	h=sender:date:from:to:cc:subject:message-id:references:mime-version
	:content-type:content-disposition:in-reply-to:user-agent;
	bh=PdoKYwtkTAigKoAWy/1Um6HeL7RDYOm4X7a8uLmBMzs=;
	b=xGzC9E3MZObDIs5lZhk4aX9BhsaST8REK4oYIPzacf/ld+q694dA52Kp0VXMCqLq7n
	Z6Z9h88oV3GkJ4ipNa+telWkKncgf7ohLh2DrDdyoeoik2eDc9R0wqxkgYXVxJxWAt+x
	LVMr3BL7dknrC1Nha51Bs6qD/PU8g6GtSy+G0P/hnqKMLAT5ktoJheiWktQRg8Qw9BfE
	B/pJVp9URNxh+OTzASBStdkXNRMFARUKev8gLAHhcDzba9lZc7zzNurZwIRQGePPKZWk
	UrLUaaL8RhunZ2vALeyJNb23SZb5sGyk6Oj2m1bs+/E696vpcKlSvzxiUap3TZh63XG9
	R2CA==
Content-Disposition: inline
In-Reply-To: <20130824182005.GA15897-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
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
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org

On Sat, Aug 24, 2013 at 08:20:05PM +0200, Michal Hocko wrote:
> On Wed 21-08-13 16:12:39, Tejun Heo wrote:
> > Li, Michal, ping.
> 
> I am sorry, I was mostly offline for the last week with very poor
> internet connection. I will try to get to this next week.

Eh well, it's nothing urgent.  Doing this after the merge window is
perfectly fine too.  Enjoy the offline-ness.

Thanks.

-- 
tejun
