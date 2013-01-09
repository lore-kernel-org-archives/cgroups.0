From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHSET] cpuset: decouple cpuset locking from cgroup core,
	take#2
Date: Wed, 9 Jan 2013 10:57:24 -0800
Message-ID: <20130109185724.GP3926@htj.dyndns.org>
References: <1357248967-24959-1-git-send-email-tj@kernel.org>
	<50E93554.3070102@huawei.com>
	<20130107164453.GH3926@htj.dyndns.org>
	<50EB76DF.5070508@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20120113;
	h=x-received:sender:date:from:to:cc:subject:message-id:references
	:mime-version:content-type:content-disposition:in-reply-to
	:user-agent; bh=msT/umeTqmmjS09yTUh1NbZuW2dF6YWnpQrn/748+lQ=;
	b=vTHBaqdQbU26g9PXiZ7CQDoeUeSGFsWQS9Q+jZCDMPr7rnOL6mo/Fjc03Ebmspl85A
	7LYps1F6uZMjIz4U3CdSw4yt+V6n9cLMlHaw+4PLan9J1JPwb4yHjuK6ekIixptD7pTQ
	TrNVFZ/et42e/bDU+S86i/s3+QY3nEaToIphpWXTl7Q8lTJw7LK9ts+jy0pDe70yFR5t
	F86vlS4F+7RzlisOOyUZ6FPj95GxYsZL/KbfRhX2weaYXpnY7L0ZdYAHeByYeZehEAkH
	Dwg4My6kbFJu8IVvv2S8qLkR9t7ph15VlpMw+fYAoeUfIIRl8C3vb2lW4yCW5KaTLiFZ
	Blww==
Content-Disposition: inline
In-Reply-To: <50EB76DF.5070508-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
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
Cc: paul-inf54ven1CmVyaH7bEyXVA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org

Hello, Li.

On Tue, Jan 08, 2013 at 09:31:11AM +0800, Li Zefan wrote:
> I don't think Paul's still maintaining cpusets. Normally it's Andrew
> that picks up cpuset patches. It's fine you route it through cgroup
> tree.

Can you please take over the cpuset maintainership then?  I think you
would be the one most familiar with the code base at this point.

Thanks.

-- 
tejun
